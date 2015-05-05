#import "RouteViewController.h"
#import "DisplayMapViewController.h"
#import "KeyPoint+Annotation.h"

@interface RouteViewController ()
@property (weak, nonatomic) DisplayMapViewController * mapViewController;

@end

@implementation RouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"MapSegue"]) {
        NSLog(@"Get the handler of Map!");
        self.mapViewController = segue.destinationViewController;
        // Do any additional setup after loading the view.
        //    CLLocationCoordinate2D zoomLocation;
        //    zoomLocation.latitude = 39.281516;
        //    zoomLocation.longitude= -76.580806;
        //    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1000, 1000);
        //    [self.mapView setRegion:viewRegion animated:YES];
        CLLocationCoordinate2D eventLocation;
        eventLocation.latitude = 39.281516;
        eventLocation.longitude= -76.580806;
        KeyPoint *keyPoint = [[KeyPoint alloc] initWithTitle: @"Net Cat" withContent: @"Cat downloaded from the Internet" withLatitude:eventLocation.latitude withLongitude:eventLocation.longitude withPhoto:[UIImage imageNamed:@"cat.jpg"]];
        self.mapViewController.keyPoints = [NSMutableArray arrayWithArray:@[keyPoint]];
        //self.mapViewController.routePoints = @[routePoint1, routePoint2, routePoint3];
    }
}

- (IBAction)buttonTapped:(UIButton *)sender {
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@
         "Start"]) {
        [self.mapViewController startTracking];
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
    } else {
        [self.mapViewController stopTracking];
        [sender setTitle:@"Start" forState:UIControlStateNormal];
    }
}
@end
