#import <Foundation/Foundation.h>
#import "SnippetFilter.h"
#import "main.h"

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