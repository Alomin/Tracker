#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface DisplayMapViewController : UIViewController  <MKMapViewDelegate>

- (void) startTrackingOther;
- (void) backgroundOtherTracker;
- (void) stopTrackingOther;
- (void) startTracking;
- (void) stopTracking;
@property (strong, nonatomic) NSMutableArray *keyPoints;
@property (strong, nonatomic) NSMutableArray *routePoints;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property bool stopped;
@end
