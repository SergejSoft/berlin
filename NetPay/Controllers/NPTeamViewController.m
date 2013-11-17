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
#import "NPPaymentService.h"
#import <CSNotificationView/CSNotificationView.h>

@interface NPTeamViewController ()

@property (nonatomic, strong) NSArray *employees;
@property (nonatomic, strong) NPEmployeeService *employeeService;
@property (nonatomic, strong) NSArray *payments;

@end

@implementation NPTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    [self.tableView setEditing:YES animated:YES];
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

- (IBAction)stepperValueDidChange:(UIStepper *)sender {
    NPEmployeeCell *cell = (NPEmployeeCell *)[[[sender superview] superview] superview];
    NSInteger hour = (NSInteger)floor(sender.value) / 60;
    NSInteger min = ((NSInteger)floor(roundf(sender.value))) % 60;

    cell.hoursWorkedLabel.text = [NSString stringWithFormat:@"%ld:%02ld", (long)hour, (long)min];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *employee = self.employees[indexPath.row];
    [employee setValue:@(sender.value) forKey:@"minutesWorked"];
}


- (IBAction)selectAllButtonTapped:(id)sender {
}

- (IBAction)deselectAllButtonTapped:(id)sender {
}


- (IBAction)payButtonTapped:(id)sender {

    for (NSInteger i = 0; i < self.employees.count; i++) {
        NSDictionary *employee = self.employees[i];
        CGFloat minutesWorked = [employee[@"minutesWorked"] floatValue] ?: 1440;
        CGFloat minutelyRate = [(NSString *)employee[@"hourlyRate"] floatValue] / 60;
        CGFloat totalDue = (minutesWorked * minutelyRate) / 60;
        NSString *amountString = [NSString stringWithFormat:@"%2f", totalDue];
        NSDictionary *payment = @{@"paypalEmail": employee[@"emailAddress"],
                                  @"amount": amountString,
                                  @"phoneNumber": employee[@"phoneNumber"]};
        [[NPPaymentService sharedService] addItem:payment completion:^{
            if (i == self.employees.count -1) {
                [CSNotificationView showInViewController:self style:CSNotificationViewStyleSuccess message:@"Successfully paid everyone!"];
            }
        }];
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
    cell.stepper.transform = CGAffineTransformMakeScale(0.75, 0.75);
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
