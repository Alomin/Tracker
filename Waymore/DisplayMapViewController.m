#import "DisplayMapViewController.h"
#import "Mapkit/MapKit.h"
#import "KeyPoint+Annotation.h"
#import "ImageScrollViewController.h"
#import "AnnotationSettingViewController.h"
#import "CoreLocation/CoreLocation.h"
#import "CrumbPath.h"
#import "CrumbPathRenderer.h"
#import "MapPoint.h"
#import "DataAccessManager.h"

#define LEFT 0
#define RIGHT 1

@interface DisplayMapViewController () <CLLocationManagerDelegate>
@property (strong, nonatomic) NSArray *infoList;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CrumbPath *crumbs;
@property (nonatomic, strong) CrumbPathRenderer *crumbPathRenderer;
@end

@implementation DisplayMapViewController


- (NSArray *) infoList {
    if(_infoList == nil) {
        _infoList = [[NSArray alloc] init];
    }
    return _infoList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        NSLog(@"Ask for permission");
        [self.locationManager requestAlwaysAuthorization];
        
    }
    
    [self.mapView setDelegate: self];
    self.mapView.showsUserLocation = YES;
    [self updateMapView];
    
}

- (void)viewWillAppear:(BOOL)animated {

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If the annotation is the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[KeyPoint class]])
    {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView*    pinView = (MKPinAnnotationView*)[mapView
                                                                 dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:@"CustomPinAnnotationView"];
        }
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        if([annotation isKindOfClass:[KeyPoint class]]) {
            KeyPoint *keyPoint = (KeyPoint *) annotation;
            if(keyPoint.photo != nil) {
                UIButton *leftButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 46, 46)];
                [leftButton setImage:keyPoint.photo forState:UIControlStateNormal];
                leftButton.tag = LEFT;
                pinView.leftCalloutAccessoryView = leftButton;
            }
            
            
            UIButton *disclosureButton = [[UIButton alloc] init];
            disclosureButton.frame = CGRectMake(0, 0, 46, 46);
			//[disclosureButton setTitle:@"Edit" forState:UIControlStateNormal];
            [disclosureButton setTitleColor:self.view.tintColor forState:UIControlStateNormal];
            disclosureButton.tag = RIGHT;
            pinView.rightCalloutAccessoryView = disclosureButton;
            
        }
        
        pinView.annotation = annotation;
        
        return pinView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if([control isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *) control;
        if(button.tag == LEFT) {
            [self performSegueWithIdentifier:@"PictureDetailSegue" sender:view];
		} else if (button.tag == RIGHT) {
            [self performSegueWithIdentifier:@"EditSegue" sender:view];
        }
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"PictureDetailSegue"] && [sender isKindOfClass:[MKAnnotationView class]]){
        MKAnnotationView *view = sender;
        KeyPoint *kp = view.annotation;
        ImageScrollViewController *imageScrollViewController = segue.destinationViewController;
        imageScrollViewController.image = kp.photo;
    }
    if([segue.identifier isEqualToString:@"EditSegue"] && [sender isKindOfClass:[MKAnnotationView class]]){
        MKAnnotationView *view = sender;
        KeyPoint *kp = (KeyPoint *)view.annotation;
        AnnotationSettingViewController *annotationSettingViewController = segue.destinationViewController;
        annotationSettingViewController.inputKeyPoint = kp;
    }
    if([segue.identifier isEqualToString:@"EditSegue"] && [sender isKindOfClass:[KeyPoint class]]){
        KeyPoint *kp = sender;
        AnnotationSettingViewController *annotationSettingViewController = segue.destinationViewController;
        annotationSettingViewController.inputKeyPoint = kp;
        annotationSettingViewController.isCreateNew = YES;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)longPressed:(UILongPressGestureRecognizer *)sender {
    // Here we get the CGPoint for the touch and convert it to latitude and longitude coordinates to display on the map
    CGPoint point = [sender locationInView:self.mapView];
    CLLocationCoordinate2D location = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    NSLog(@"Location found from Map: %f %f",location.latitude,location.longitude);
    KeyPoint *newKeyPoint = [[KeyPoint alloc] initWithTitle:@"Title" withContent:@"Content" withLatitude:location.latitude withLongitude:location.longitude withPhoto:NULL];
    [self performSegueWithIdentifier:@"EditSegue" sender:newKeyPoint];
}


- (IBAction)settingBack:(UIStoryboardSegue *)unwindSegue {
    if ([unwindSegue.sourceViewController isKindOfClass: [AnnotationSettingViewController class]]) {
        AnnotationSettingViewController *annotationSettingViewController = (AnnotationSettingViewController *) unwindSegue.sourceViewController;
        if (annotationSettingViewController.isCreateNew) {
            NSLog(@"Create new");
            NSLog(@"%@",annotationSettingViewController.outputKeyPoint.title);
            [self.mapView addAnnotation:annotationSettingViewController.outputKeyPoint];
        } else {
            annotationSettingViewController.inputKeyPoint.title = annotationSettingViewController.outputKeyPoint.title;
            annotationSettingViewController.inputKeyPoint.content = annotationSettingViewController.outputKeyPoint.content;
            annotationSettingViewController.inputKeyPoint.photo = annotationSettingViewController.outputKeyPoint.photo;
            [self.mapView removeAnnotation:annotationSettingViewController.inputKeyPoint];
            [self.mapView addAnnotation:annotationSettingViewController.inputKeyPoint];
            [self.mapView selectAnnotation:annotationSettingViewController.inputKeyPoint animated:NO];
            
        }
    }
    
}

- (void)startTracking{
    NSLog(@"start tracing");
	
	//Self tracking
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.activityType = CLActivityTypeFitness;
    self.locationManager.distanceFilter = 10; // meters
    [self.locationManager startUpdatingLocation];
}

- (void) stopTracking {
    NSLog(@"stop tracing");
    [self.locationManager stopUpdatingLocation];
}

- (MKCoordinateRegion)coordinateRegionWithCenter:(CLLocationCoordinate2D)centerCoordinate approximateRadiusInMeters:(CLLocationDistance)radiusInMeters
{
    // Multiplying by MKMapPointsPerMeterAtLatitude at the center is only approximate, since latitude isn't fixed
    //
    double radiusInMapPoints = radiusInMeters*MKMapPointsPerMeterAtLatitude(centerCoordinate.latitude);
    MKMapSize radiusSquared = {radiusInMapPoints,radiusInMapPoints};
    
    MKMapPoint regionOrigin = MKMapPointForCoordinate(centerCoordinate);
    MKMapRect regionRect = (MKMapRect){regionOrigin, radiusSquared}; //origin is the top-left corner
    
    regionRect = MKMapRectOffset(regionRect, -radiusInMapPoints/2, -radiusInMapPoints/2);
    
    // clamp the rect to be within the world
    regionRect = MKMapRectIntersection(regionRect, MKMapRectWorld);
    
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(regionRect);
    return region;
}

- (CLLocationManager*) locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

- (void) startTrackingOther {
	dispatch_queue_t queue = [[DataAccessManager getInstance] queue];
		dispatch_async(queue,^{
			[self backgroundOtherTracker];
		});
}

- (void) stopTrackingOther {
	NSLog(@"Called stopTrackingOther");
	[self setStopped:YES];
	[NSThread sleepForTimeInterval:0.1f];
	[self setCrumbs:nil];
	[self.mapView removeOverlays:self.mapView.overlays];
}

- (void) backgroundOtherTracker {
	NSLog(@"Called bakcgroundOtherTracker");
	[self setStopped:NO];
	DataAccessManager *dam = [DataAccessManager getInstance];
	while (!_stopped) {
		[dam sendKeywords:dam.tarId];
		if (![dam newlocation])
			continue;
		NSArray *loc = [dam newlocation];
		float data[] = {[loc[0] floatValue], [loc[1] floatValue]};
		[self updateOtherWithLocation:data];
		[NSThread sleepForTimeInterval:0.5f];
	}
}

- (void) updateOtherWithLocation:(float [])location {
	if (location != nil)
	{
		// we are not using deferred location updates, so always use the latest location
		CLLocation *newLocation = [[CLLocation alloc]initWithLatitude:location[0]
															longitude:location[1]];
		NSLog(@"Got data %f and %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
		
		[self.routePoints addObject:[[MapPoint alloc] initWithLatitude:newLocation.coordinate.latitude withLongitude:newLocation.coordinate.longitude withTime:[NSDate date]]];
		if (self.crumbs == nil)
		{
			// This is the first time we're getting a location update, so create
			// the CrumbPath and add it to the map.
			//
			_crumbs = [[CrumbPath alloc] initWithCenterCoordinate:newLocation.coordinate];
			
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.mapView addOverlay:self.crumbs level:MKOverlayLevelAboveRoads];
			});
			
			// on the first location update only, zoom map to user location
			CLLocationCoordinate2D newCoordinate = newLocation.coordinate;
			
			// default -boundingMapRect size is 1km^2 centered on coord
			MKCoordinateRegion region = [self coordinateRegionWithCenter:newCoordinate approximateRadiusInMeters:2500];
			
			[self.mapView setRegion:region animated:YES];
		}
		else
		{
			// This is a subsequent location update.
			//
			// If the crumbs MKOverlay model object determines that the current location has moved
			// far enough from the previous location, use the returned updateRect to redraw just
			// the changed area.
			//
			// note: cell-based devices will locate you using the triangulation of the cell towers.
			// so you may experience spikes in location data (in small time intervals)
			// due to cell tower triangulation.
			//
			BOOL boundingMapRectChanged = NO;
			MKMapRect updateRect = [self.crumbs addCoordinate:newLocation.coordinate boundingMapRectChanged:&boundingMapRectChanged];
			if (boundingMapRectChanged)
			{
				// MKMapView expects an overlay's boundingMapRect to never change (it's a readonly @property).
				// So for the MapView to recognize the overlay's size has changed, we remove it, then add it again.
				[self.mapView removeOverlays:self.mapView.overlays];
				_crumbPathRenderer = nil;
				[self.mapView addOverlay:self.crumbs level:MKOverlayLevelAboveRoads];
			}
			else if (!MKMapRectIsNull(updateRect))
			{
				// There is a non null update rect.
				// Compute the currently visible map zoom scale.
				MKZoomScale currentZoomScale = (CGFloat)(self.mapView.bounds.size.width / self.mapView.visibleMapRect.size.width);
				// Find out the line width at this zoom scale and outset the updateRect by that amount
				CGFloat lineWidth = MKRoadWidthAtZoomScale(currentZoomScale);
				updateRect = MKMapRectInset(updateRect, -lineWidth, -lineWidth);
				// Ask the overlay view to update just the changed area.
				[self.crumbPathRenderer setNeedsDisplayInMapRect:updateRect];
			}
		}
	}
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (locations != nil && locations.count > 0)
    {
        // we are not using deferred location updates, so always use the latest location
        CLLocation *newLocation = locations[0];
		DataAccessManager *dam = [DataAccessManager getInstance];
		[dam sendLocationwithLat:newLocation.coordinate.latitude
						  andLon:newLocation.coordinate.longitude];
		
        [self.routePoints addObject:[[MapPoint alloc] initWithLatitude:newLocation.coordinate.latitude withLongitude:newLocation.coordinate.longitude withTime:[NSDate date]]];
        if (self.crumbs == nil)
        {
            // This is the first time we're getting a location update, so create
            // the CrumbPath and add it to the map.
            //
            _crumbs = [[CrumbPath alloc] initWithCenterCoordinate:newLocation.coordinate];
            [self.mapView addOverlay:self.crumbs level:MKOverlayLevelAboveRoads];
            
            // on the first location update only, zoom map to user location
            CLLocationCoordinate2D newCoordinate = newLocation.coordinate;
            
            // default -boundingMapRect size is 1km^2 centered on coord
            MKCoordinateRegion region = [self coordinateRegionWithCenter:newCoordinate approximateRadiusInMeters:2500];
            
            [self.mapView setRegion:region animated:YES];
        }
        else
        {
            // This is a subsequent location update.
            //
            // If the crumbs MKOverlay model object determines that the current location has moved
            // far enough from the previous location, use the returned updateRect to redraw just
            // the changed area.
            //
            // note: cell-based devices will locate you using the triangulation of the cell towers.
            // so you may experience spikes in location data (in small time intervals)
            // due to cell tower triangulation.
            //
            BOOL boundingMapRectChanged = NO;
            MKMapRect updateRect = [self.crumbs addCoordinate:newLocation.coordinate boundingMapRectChanged:&boundingMapRectChanged];
            if (boundingMapRectChanged)
            {
                // MKMapView expects an overlay's boundingMapRect to never change (it's a readonly @property).
                // So for the MapView to recognize the overlay's size has changed, we remove it, then add it again.
                [self.mapView removeOverlays:self.mapView.overlays];
                _crumbPathRenderer = nil;
                [self.mapView addOverlay:self.crumbs level:MKOverlayLevelAboveRoads];
            }
            else if (!MKMapRectIsNull(updateRect))
            {
				//NSLog(@"cord 1 : %f and cord 2 : %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
				DataAccessManager *dam = [DataAccessManager getInstance];
				[dam sendLocationwithLat:newLocation.coordinate.latitude
								  andLon:newLocation.coordinate.longitude];
                // There is a non null update rect.
                // Compute the currently visible map zoom scale.
                MKZoomScale currentZoomScale = (CGFloat)(self.mapView.bounds.size.width / self.mapView.visibleMapRect.size.width);
                // Find out the line width at this zoom scale and outset the updateRect by that amount
                CGFloat lineWidth = MKRoadWidthAtZoomScale(currentZoomScale);
                updateRect = MKMapRectInset(updateRect, -lineWidth, -lineWidth);
                // Ask the overlay view to update just the changed area.
                [self.crumbPathRenderer setNeedsDisplayInMapRect:updateRect];
            }
        }
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    MKOverlayRenderer *renderer = nil;
    
    if ([overlay isKindOfClass:[CrumbPath class]])
    {
        if (self.crumbPathRenderer == nil)
        {
            _crumbPathRenderer = [[CrumbPathRenderer alloc] initWithOverlay:overlay];
        }
        renderer = self.crumbPathRenderer;
    }
    else if ([overlay isKindOfClass:[MKPolygon class]])
    {
#if kDebugShowArea
        if (![self.drawingAreaRenderer.polygon isEqual:overlay])
        {
            _drawingAreaRenderer = [[MKPolygonRenderer alloc] initWithPolygon:overlay];
            self.drawingAreaRenderer.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.25];
        }
        renderer = self.drawingAreaRenderer;
#endif
    }
    
    return renderer;
}

@synthesize keyPoints = _keyPoints;
@synthesize routePoints = _routePoints;

- (NSArray *) keyPoints {
    if(_keyPoints == nil) {
        _keyPoints = [[NSMutableArray alloc] init];
    }
    return _keyPoints;
}

- (NSArray *) routePoints {
    if(_routePoints == nil) {
        _routePoints = [[NSMutableArray alloc] init];
    }
    return _routePoints;
}

- (void) setKeyPoints:(NSArray *)keyPoints {
    _keyPoints = [NSMutableArray arrayWithArray:keyPoints];
    [self updateMapView];
}

- (void) setRoutePoints:(NSArray *)routePoints {
    _routePoints = [NSMutableArray arrayWithArray:routePoints];
    BOOL boundingMapectChanged = NO;
    if (self.crumbs == nil) {
        MapPoint *point0 = [routePoints objectAtIndex:0];
        self.crumbs = [[CrumbPath alloc] initWithCenterCoordinate:CLLocationCoordinate2DMake(point0.latitude, point0.longitude)];
    }
    for(MapPoint *mapPoint in routePoints) {
        [self.crumbs addCoordinate:CLLocationCoordinate2DMake(mapPoint.latitude, mapPoint.longitude) boundingMapRectChanged:&boundingMapectChanged];
    }
    [self updateMapView];
}

- (void) updateMapView {
    for(id annotation in self.mapView.annotations) {
        if([annotation isKindOfClass:[KeyPoint class]]) {
            [self.mapView removeAnnotations:annotation];
        }
    }
    for(KeyPoint *keyPoint in self.keyPoints) {
        [self.mapView addAnnotation:keyPoint];
    }
    [self.mapView removeOverlays:self.mapView.overlays];
    if(self.crumbs != nil) {
        [self.mapView addOverlay:self.crumbs level:MKOverlayLevelAboveRoads];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
