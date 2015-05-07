//
//  OtherViewController.m
//  Tracker
//
//  Created by Tianlong Li on 5/5/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "OtherViewController.h"

@interface OtherViewController ()

@end

@implementation OtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refresher:(UIBarButtonItem *)sender {
	[self.mapViewController stopTrackingOther];
	[self inputCheck];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		NSString *pw = [alertView textFieldAtIndex:0].text;
		NSLog(@"input is %@", pw);
		NSArray *rep = [[DataAccessManager getInstance] sendKeywords:pw];
		if (YES])
			[self inputCheck];
		else if ([self.mapViewController stopped]) {
			[self.mapViewController startTrackingOther];
		} else {
			[self performSegueWithIdentifier:@"OtherSegue"
									  sender:nil];
		}
	}
}

- (void)inputCheck {
	UIAlertView *alertview = [[UIAlertView alloc]
							  initWithTitle:@"Track"
							  message:@"Please enter the ID of your interest"
							  delegate:self
							  cancelButtonTitle:nil
							  otherButtonTitles:@"Go!", nil];
	[alertview setAlertViewStyle:UIAlertViewStyleSecureTextInput];
	[alertview show];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
	[self inputCheck];
	return NO;
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
