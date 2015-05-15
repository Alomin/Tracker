#import <UIKit/UIKit.h>
#import "KeyPoint.h"

@interface AnnotationSettingViewController : UIViewController

@property (assign, nonatomic) BOOL isCreateNew;
@property (strong, nonatomic) KeyPoint *inputKeyPoint;
@property (strong, nonatomic) KeyPoint *outputKeyPoint;

@end

