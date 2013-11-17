//
//  NPAddTeamViewController.h
//  NetPay
//
//  Created by Jurre Stender on 16/11/13.
//  Copyright (c) 2013 NetPay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPTeamService.h"

@interface NPAddTeamViewController : UIViewController

@property (nonatomic, strong) NPTeamService *teamService;
@property (weak, nonatomic) IBOutlet UITextField *teamNameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)addButtonTapped:(id)sender;

@end
