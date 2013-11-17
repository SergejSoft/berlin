//
//  NPTeamViewController.m
//  NetPay
//
//  Created by Jurre Stender on 16/11/13.
//  Copyright (c) 2013 NetPay. All rights reserved.
//

#import "NPTeamViewController.h"
#import "NPAddEmployeeViewController.h"

@interface NPTeamViewController ()

@end

@implementation NPTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NPAddEmployeeSegue"]) {
        // lol, who needs models when you have dictionaries
        UINavigationController *nav = segue.destinationViewController;
        ((NPAddEmployeeViewController *)nav.topViewController).teamId = [self.team[@"id"] integerValue];
    }
}

@end
