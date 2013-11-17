//
//  NPTeamsViewController.m
//  NetPay
//
//  Created by Jurre Stender on 16/11/13.
//  Copyright (c) 2013 NetPay. All rights reserved.
//

#import "NPTeamsViewController.h"
#import "NPTeamCell.h"
#import <SSKeychain/SSKeychain.h>

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
    } else if ([self currentUser]) {
        self.teamService.client.currentUser = [self currentUser];
        [self refresh];
    } else {
        [client loginWithProvider:@"microsoftaccount" controller:self animated:YES completion:^(MSUser *user, NSError *error) {
            [SSKeychain setPassword:user.userId forService:@"NetPay" account:@"userId"];
            [SSKeychain setPassword:user.mobileServiceAuthenticationToken forService:@"NetPay" account:@"authToken"];
            [self refresh];
        }];
    }
}

- (MSUser *)currentUser {
    NSString *userId = [SSKeychain passwordForService:@"NetPay" account:@"userId"];
    NSString *authToken = [SSKeychain passwordForService:@"NetPay" account:@"authToken"];

    if (userId && authToken) {
        MSUser *user = [[MSUser alloc] initWithUserId:userId];
        user.mobileServiceAuthenticationToken = authToken;
        return user;
    } else {
        return nil;
    }
}


- (void) refresh {
    [self.refreshControl beginRefreshing];
    [self.teamService refreshDataOnSuccess:^{
         [self.refreshControl endRefreshing];
         [self.tableView reloadData];
     }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.teamService.teams count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NPTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:NPTeamsCellIdentifier forIndexPath:indexPath];

    cell.iconImageView.image = [UIImage imageNamed:@"Construction"];
    cell.teamNameLabel.text = self.teamService.teams[indexPath.row][@"name"];

    return cell;
}

@end
