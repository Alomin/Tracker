#import "DataAccessManager.h"
#import "keyPoint.h"

@interface DataAccessManager()

@end

@implementation DataAccessManager

+ (id) getInstance {
    static DataAccessManager *DAMInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DAMInstance = [[self alloc] init];
    });
    return DAMInstance;
}

- (id) init {
    if (self = [super init]) {
        self.Users = [[NSMutableArray alloc] init];
        self.Routes = [[NSMutableArray alloc] init];
        self.LocalRoutes = [[NSMutableArray alloc] init];
        self.LocalSnippets = [[NSMutableArray alloc] init];
		self.queue = dispatch_queue_create("my queue", nil);
    }
    return self;
}

- (void)setUserId:(NSString *)newValue {
    _userId = newValue;
}

- (NSString *) getID {
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://52.6.51.207:80"]];
    [urlRequest setValue:@"getPW" forHTTPHeaderField:@"Message-Type"];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    
    NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.userId = newStr;
    NSLog(@"=====id: %@ =========", self.userId);
    return newStr;
}

- (NSArray *) sendKeywords: (NSString *) kw {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://52.6.51.207:80"]];
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"GET";
    
    // This is how we set header fields
    [request setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"downLoad" forHTTPHeaderField:@"Message-Type"];
    [request setValue:kw forHTTPHeaderField:@"UserId"];
    
    // Convert your data and set your request's HTTPBody property
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    //NSError * error;
    NSDictionary * mylocation = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString * lat = [mylocation objectForKey:@"lat"];
    NSString * lon = [mylocation objectForKey:@"lon"];
    self.newlocation = @[lat,lon];
    return self.newlocation;
    
    //NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];

    //request.HTTPBody = postdata;
    
    // Create url connection and fire request
    //NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}



- (void) sendLocationwithLat:(float) lat andLon:(float) lon{
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://52.6.51.207:80"]];
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"POST";
    
    // This is how we set header fields
    [request setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"upLoad" forHTTPHeaderField:@"Message-Type"];
    [request setValue:self.userId forHTTPHeaderField:@"UserId"];
    
    // Convert your data and set your request's HTTPBody property
    NSString *sendlat = [NSString stringWithFormat:@"%f", lat];
    NSString *sendlon = [NSString stringWithFormat:@"%f", lon];
    
    //NSLog(@"lat: %@" ,sendlat);
    //NSLog(@"lon: %@" ,sendlon);
    //NSLog(@"id: %@" ,self.userId);
    
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         sendlat, @"lat",
                         sendlon, @"lon",
                         nil];

    NSError *error ;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    //NSData *fakedata = [NSJSONSerialization dataWithJSONObject:fake options:0 error:&error];
    //NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = postdata;
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}



#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
    NSLog(@"Init Receive");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
    NSLog(@"Receive");
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    NSLog(@"Cache");
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSLog(@"Finish");
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"Error");
    
}

@end
