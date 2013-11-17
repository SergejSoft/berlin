//
//  NPTeamViewController.h
//  NetPay
//
//  Created by Jurre Stender on 16/11/13.
//  Copyright (c) 2013 NetPay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPTeamViewController : UIViewController

@property (nonatomic, strong) NSDictionary *team;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
