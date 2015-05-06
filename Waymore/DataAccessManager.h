#import <Foundation/Foundation.h>

=======
#import "Route.h"
#import "WaymoreUser.h"
#import "SnippetFilter.h"
#import "Comment.h"
#import "main.h"
>>>>>>> d0cfccb20dc2acaea10090ed0adf6bc8c81e96eb
@interface DataAccessManager : NSObject <NSURLConnectionDelegate>{
	NSMutableData *_responseData;
}

@property (nonatomic, strong) NSString * userId;
@property NSMutableArray * Users;
@property NSMutableArray * Routes;
@property NSMutableArray * LocalRoutes;
@property NSMutableArray * LocalSnippets;

+ (id) getInstance;

- (NSString *) getID;
- (void) sendLocationwithLat:(float) lat andLon:(float) lon;
- (BOOL) addUser: (NSString *) userId;
- (NSArray *) getRoutesWithUserId: (NSString *) userId;
- (BOOL) deleteLocalRouteWithRouteId: (NSString *) routeId;
- (BOOL) setShareSetting: (NSString *) routeId isShare: (BOOL) flag;
- (BOOL) deleteRouteWithRouteId: (NSString *) routeId;
- (BOOL) setLike: (NSString *) routeId withUserId: (NSString *) userId isLike: (BOOL) flag;
- (NSString *) addComment: (NSString *) content withRouteId: (NSString *) routeId withUserId: (NSString *) userId;

@end