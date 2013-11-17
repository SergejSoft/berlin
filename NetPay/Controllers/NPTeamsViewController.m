//
//  NPTeamsViewController.m
//  NetPay
//
//  Created by Jurre Stender on 16/11/13.
//  Copyright (c) 2013 NetPay. All rights reserved.
//

#import "NPTeamsViewController.h"
#import "NPTeamCell.h"
#import <NSData+Base64/NSData+Base64.h>
#import <SSKeychain/SSKeychain.h>
#import "NPTeamViewController.h"

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
        [self refresh];
        return;
    } else {
        [client loginWithProvider:@"microsoftaccount" controller:self animated:YES completion:^(MSUser *user, NSError *error) {
            [SSKeychain setPassword:user.userId forService:@"NetPay" account:@"userId"];
            [SSKeychain setPassword:user.mobileServiceAuthenticationToken forService:@"NetPay" account:@"authToken"];
            [self refresh];
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refresh];
}


- (void)refresh {
    [self.refreshControl beginRefreshing];
    [self.teamService refreshDataWithCompletion:^{
         [self.refreshControl endRefreshing];
         [self.tableView reloadData];
     }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NPTeamSelectionSegue"]) {
        ((NPTeamViewController *)segue.destinationViewController).team = self.teamService.teams[[self.tableView indexPathForSelectedRow].row];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.teamService.teams count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NPTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:NPTeamsCellIdentifier forIndexPath:indexPath];

    NSDictionary *team = self.teamService.teams[indexPath.row];
    if (![(NSNull *)team[@"imageData"] isEqual:[NSNull null]]) {;
        CALayer *layer = [cell.iconImageView layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:20.0];

        NSData *data = [NSData dataFromBase64String:team[@"imageData"]];
        UIImage *image = [UIImage imageWithData:data];
        
        cell.iconImageView.image = image;
    } else {
        cell.iconImageView.image = [UIImage imageNamed:@"Construction"];
    }
    cell.teamNameLabel.text = team[@"name"];

    return cell;
}

@end
