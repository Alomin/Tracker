#import <Foundation/Foundation.h>

@interface DataAccessManager : NSObject <NSURLConnectionDelegate>{
	NSMutableData *_responseData;
}

@property (nonatomic, strong) NSString * userId;
@property NSMutableArray * Users;
@property NSMutableArray * Routes;
@property NSMutableArray * LocalRoutes;
@property NSMutableArray * LocalSnippets;
@property dispatch_queue_t queue;

+ (id) getInstance;

- (NSString *) getID;
- (void) sendLocationwithLat:(float) lat andLon:(float) lon;

@end