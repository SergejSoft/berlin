//
//  NPTeamsViewController.m
//  NetPay
//
//  Created by Jurre Stender on 16/11/13.
//  Copyright (c) 2013 NetPay. All rights reserved.
//

#import "NPTeamsViewController.h"
#import "NPTeamCell.h"

static NSString *NPTeamsCellIdentifier = @"NPTeamsCellIdentifier";

@interface NPTeamsViewController ()

@end

@implementation NPTeamsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NPTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:NPTeamsCellIdentifier forIndexPath:indexPath];

    cell.iconImageView.image = [UIImage imageNamed:@"Construction"];

    return cell;
}

@end
