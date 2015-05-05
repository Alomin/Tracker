#import "DataAccessManager.h"
#import "keyPoint.h"
#import "Snippet.h"

@interface DataAccessManager()
//@property NSMutableArray * Users;
//@property NSMutableArray * Routes;
//@property NSMutableArray * Snippets;
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
	}
	
	KeyPoint *keyPoint = [[KeyPoint alloc] initWithTitle: @"Net Cat" withContent: @"Cat downloaded from the Internet" withLatitude:39.281516 withLongitude:-76.580806 withPhoto:[UIImage imageNamed:@"cat.jpg"]];
	Route *route = [[Route alloc] init];
	route.keyPoints = @[keyPoint];
	route.city = @"New York";
	route.mapPoints = @[];
	//route.userIdsWhoLike = @[];
	//route.userIdsWhoLike = @[];
	//route.userIdWhoCreates = @"user_id_1";
	
	[self putLocalRoute:route];
	[self uploadRoute:route];
	
	return self;
}

- (NSString *) getID {
	return @"haha";
}

@end
