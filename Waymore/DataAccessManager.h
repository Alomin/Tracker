#import <Foundation/Foundation.h>
#import "Route.h"
#import "WaymoreUser.h"
#import "SnippetFilter.h"
#import "Comment.h"

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
- (void) sendLocationwithLat:(float) lat andLon:(float) lon byUser: (NSString *) userid;
- (BOOL) addUser: (NSString *) userId;
- (WaymoreUser *) getUserWithUserId: (NSString *) userId;
- (NSArray *) getSnippetWithFilter: (SnippetFilter *) snippetFilter;
- (NSArray *) getLocalSnippetWithFilter: (SnippetFilter *) snippetFilter;
- (Route *) getRouteWithRouteId: (NSString *) routeId;
- (Route *) getLocalRouteWithRouteId: (NSString *) routeId;
- (NSArray *) getRoutesWithUserId: (NSString *) userId;
- (NSString *) putLocalRoute: (Route *) route;
- (BOOL) uploadRoute: (Route *) route;
- (BOOL) deleteLocalRouteWithRouteId: (NSString *) routeId;
- (BOOL) setShareSetting: (NSString *) routeId isShare: (BOOL) flag;
- (BOOL) deleteRouteWithRouteId: (NSString *) routeId;
- (BOOL) setLike: (NSString *) routeId withUserId: (NSString *) userId isLike: (BOOL) flag;
- (NSString *) addComment: (NSString *) content withRouteId: (NSString *) routeId withUserId: (NSString *) userId;

@end