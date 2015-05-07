#import "RouteViewController.h"
#import "KeyPoint+Annotation.h"

@interface RouteViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end

@implementation RouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSString *uniqueID = [NSString stringWithFormat:@"Your unique ID: nonono"];
	self.navigationItem.title = uniqueID;
	if (self.startButton)
		self.startButton.layer.cornerRadius = self.startButton.bounds.size.width/2;
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
		}
    }
}

- (IBAction)buttonTapped:(UIButton *)sender {
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@
         "Start"]) {
		[self.mapViewController startTracking];
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
		[sender setBackgroundImage:[UIImage imageNamed:@"button-stop"] forState:UIControlStateNormal];
    } else {
        [self.mapViewController stopTracking];
        [sender setTitle:@"Start" forState:UIControlStateNormal];
		[sender setBackgroundImage:[UIImage imageNamed:@"button-play"] forState:UIControlStateNormal];

    }
}
@end
