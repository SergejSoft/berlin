//
//  NPAddEmployeeViewController.m
//  NetPay
//
//  Created by Jurre Stender on 16/11/13.
//  Copyright (c) 2013 NetPay. All rights reserved.
//

#import "NPAddEmployeeViewController.h"
#import "NPEmployeeService.h"
#import <NSData+Base64/NSData+Base64.h>

@interface NPAddEmployeeViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) NPEmployeeService *employeeService;

@end

@implementation NPAddEmployeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.employeeService = [NPEmployeeService sharedService];
}

- (IBAction)addButtonTapped:(id)sender {

    NSData *data = nil;
    NSString *imageData = nil;
    if (self.profileImageView.image != nil) {
        UIImage *image = self.profileImageView.image;
        data = UIImagePNGRepresentation(image);
        imageData = [data base64EncodedString];
    }

    NSDictionary *employee = @{@"firstName": self.firstNameTextField.text,
                               @"lastName": self.lastNameTextField.text,
                               @"emailAddress": self.emailTextField.text,
                               @"hourlyRate": self.hourlyRateTextField.text,
                               @"phoneNumber": self.phoneNumberTextField.text,
                               @"profileImage": imageData,
                               @"teamId": @(self.teamId)};

    __weak NPAddEmployeeViewController *weakSelf = self;
    [self.employeeService addItem:employee completion:^(NSUInteger index) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}


- (IBAction)addProfileImageButtonTapped:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    CGSize newSize = CGSizeMake(128, 128);

    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0, newSize.width, newSize.height)];
    UIImage *small = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    self.profileImageView.image = small;

    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
