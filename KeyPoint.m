#import "KeyPoint.h"


@implementation KeyPoint

- (KeyPoint *) initWithTitle:(NSString *)title withContent:(NSString *)content withLatitude:(double)latitude withLongitude:(double)longitude withPhoto:(UIImage *)photo{
    if (self = [super init]) {
        self.title = title;
        self.content = content;
        self.photo = photo;
        self.latitude = latitude;
        self.longitude = longitude;
    }
    return self;
}

@end
