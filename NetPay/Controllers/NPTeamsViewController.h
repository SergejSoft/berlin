//
//  NPTeamsViewController.h
//  NetPay
//
//  Created by Jurre Stender on 16/11/13.
//  Copyright (c) 2013 NetPay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPTeamService.h"

@interface NPTeamsViewController : UITableViewController

@property (nonatomic, strong) NPTeamService *teamService;

@end
