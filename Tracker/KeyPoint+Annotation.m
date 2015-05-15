#import "KeyPoint+Annotation.h"

@implementation KeyPoint (Annotation)

- (CLLocationCoordinate2D) coordinate {
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

- (NSString*) subtitle {
    return self.content;
}


@end
