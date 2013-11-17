//
//  NPEmployeeCell.h
//  NetPay
//
//  Created by Jurre Stender on 17/11/13.
//  Copyright (c) 2013 NetPay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPEmployeeCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *profileImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UILabel *hoursWorkedLabel;

@end
