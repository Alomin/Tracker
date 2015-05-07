#import <Foundation/Foundation.h>

@class WaymoreUser;

@interface Comment : NSObject

@property (nonatomic, retain) NSString * commentId;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) WaymoreUser *userWhoCreates;

@end
