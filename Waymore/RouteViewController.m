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
    if ([segueName isEqualToString: @"MapSegue"] || [segueName isEqualToString: @"OtherSegue"]) {
        self.mapViewController = segue.destinationViewController;
        CLLocationCoordinate2D eventLocation;
        eventLocation.latitude = 39.281516;
        eventLocation.longitude= -76.580806;
        KeyPoint *keyPoint = [[KeyPoint alloc] initWithTitle: @"NYC" withContent: @"Best place in the world!" withLatitude:eventLocation.latitude withLongitude:eventLocation.longitude withPhoto:[UIImage imageNamed:@"two2"]];
        self.mapViewController.keyPoints = [NSMutableArray arrayWithArray:@[keyPoint]];
		if ([segueName isEqualToString: @"OtherSegue"]) {
			self.mapViewController.keyPoints = nil;
			[self.mapViewController performSelector:@selector(startTrackingOther)
					   withObject:nil
					   afterDelay:3];
			//[self.mapViewController startTrackingWithType:1];
		}
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
