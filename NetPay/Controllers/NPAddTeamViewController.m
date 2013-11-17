//
//  NPAddTeamViewController.m
//  NetPay
//
//  Created by Jurre Stender on 16/11/13.
//  Copyright (c) 2013 NetPay. All rights reserved.
//

#import "NPAddTeamViewController.h"

@interface NPAddTeamViewController ()

@end

@implementation NPAddTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.teamService = [NPTeamService sharedService];
}

- (IBAction)addButtonTapped:(id)sender {
    if (self.teamNameTextField.text == nil || self.teamNameTextField.text.length == 0) {
        return;
    }

    NSDictionary *team = @{
                           @"name" : self.teamNameTextField.text,
                           @"type" : @"construction"
                           };

    [self.teamService addItem:team completion:^(NSUInteger index) {
    //
    }];

    self.teamNameTextField.text = @"";
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
