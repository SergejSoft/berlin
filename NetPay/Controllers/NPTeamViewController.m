//
//  NPTeamViewController.m
//  NetPay
//
//  Created by Jurre Stender on 16/11/13.
//  Copyright (c) 2013 NetPay. All rights reserved.
//

#import "NPTeamViewController.h"
#import "NPAddEmployeeViewController.h"
#import "NPEmployeeService.h"
#import "NPEmployeeCell.h"
#import <NSData+Base64/NSData+Base64.h>

@interface NPTeamViewController ()

@property (nonatomic, strong) NSArray *employees;
@property (nonatomic, strong) NPEmployeeService *employeeService;

@end

@implementation NPTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.employeeService = [NPEmployeeService sharedService];
    [self reloadEmployees];
}

- (void)reloadEmployees {
    NSInteger teamId = [self.team[@"id"] integerValue];
    [self.employeeService refreshDataForTeamId:teamId WithCompletion:^{
        self.employees = self.employeeService.employees;
        [self.tableView reloadData];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NPAddEmployeeSegue"]) {
        // lol, who needs models when you have dictionaries
        UINavigationController *nav = segue.destinationViewController;
        ((NPAddEmployeeViewController *)nav.topViewController).teamId = [self.team[@"id"] integerValue];
    }
}

#pragma mark - UITableViewDelegate/Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.employees.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NPEmployeeCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"NPEmployeeCell" forIndexPath:indexPath];

    NSDictionary *employee = self.employees[indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", employee[@"firstName"], employee[@"lastName"]];
    if (![(NSNull *)employee[@"profileImage"] isEqual:[NSNull null]]) {;
        CALayer *layer = [cell.profileImageView layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:20.0];

        NSData *data = [NSData dataFromBase64String:employee[@"profileImage"]];
        UIImage *image = [UIImage imageWithData:data];

        cell.profileImageView.image = image;
    }

    return cell;
}

@end
