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
	[self inputCheckwithType: 0];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		NSString *pw = [alertView textFieldAtIndex:0].text;
		NSLog(@"input is %@", pw);
		NSArray *rep = [[DataAccessManager getInstance] sendKeywords:pw];
		if ([rep[0] integerValue] == 500)
			[self inputCheckwithType:1];
		else if ([rep[0] integerValue] == 1000)
			[self inputCheckwithType:2];
		else if ([self.mapViewController stopped]) {
			[self.mapViewController startTrackingOther];
		} else {
			[self performSegueWithIdentifier:@"OtherSegue"
									  sender:nil];
		}
	} else
		return;
}

//0: initial
//1: wrong pw
//2: no data
- (void)inputCheckwithType:(int) type {
	UIAlertView *alertview = [[UIAlertView alloc]
							  initWithTitle:@"Track"
							  message:@"Please enter the ID of your interest"
							  delegate:self
							  cancelButtonTitle:@"No!"
							  otherButtonTitles:@"Go!", nil];
	if (type == 1)
		[alertview setMessage:@"User not found, please retry"];
	else if (type == 2)
		[alertview setMessage:@"User not online, please retry"];
	[alertview setAlertViewStyle:UIAlertViewStyleSecureTextInput];
	[alertview show];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
	[self inputCheckwithType:0];
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
