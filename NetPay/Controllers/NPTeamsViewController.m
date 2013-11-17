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

    self.teamService = [NPTeamService sharedService];

    [self refresh];

    MSClient *client = self.teamService.client;

    if (client.currentUser != nil) {
        return;
    } else {

        [client loginWithProvider:@"microsoftaccount" controller:self animated:YES completion:^(MSUser *user, NSError *error) {
            [self refresh];
        }];
    }
}


- (void) refresh {
    [self.refreshControl beginRefreshing];
    [self.teamService refreshDataOnSuccess:^{
         [self.refreshControl endRefreshing];
         [self.tableView reloadData];
     }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.teamService.teams count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NPTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:NPTeamsCellIdentifier forIndexPath:indexPath];

    cell.iconImageView.image = [UIImage imageNamed:@"Construction"];

    return cell;
}

@end
