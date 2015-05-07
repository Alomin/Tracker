//
//  MainUITBC.m
//  Tracker
//
//  Created by Tianlong Li on 5/5/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import "MainUITBC.h"
#import "DataAccessManager.h"

@interface MainUITBC ()

@end

@implementation MainUITBC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	//NSString *id = [[DataAccessManager getInstance] getID];
	NSString *id = @"yay";
	NSLog(@"id is %@",id);
	NSString *msg = [NSString stringWithFormat:@"This is your unique key: %@, please keep it safe", id];
	UIAlertView *alertview = [[UIAlertView alloc]
							  initWithTitle:@"Welcome!"
							  message:msg
							  delegate:self
							  cancelButtonTitle:nil
							  otherButtonTitles:@"Gotcha!", nil];
	[alertview show];
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
