#import "MapPoint.h"


@implementation MapPoint

- (MapPoint *) initWithLatitude:(double)latitude withLongitude:(double)longitude withTime:(NSDate *)time {
    if (self = [super init]) {
        self.latitude = latitude;
        self.longitude = longitude;
        self.time = time;
    }
    return self;
}
@end
