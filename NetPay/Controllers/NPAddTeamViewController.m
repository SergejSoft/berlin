//
//  NPAddTeamViewController.m
//  NetPay
//
//  Created by Jurre Stender on 16/11/13.
//  Copyright (c) 2013 NetPay. All rights reserved.
//

#import "NPAddTeamViewController.h"
#import <NSData+Base64/NSData+Base64.h>
#import <CSNotificationView/CSNotificationView.h>

@interface NPAddTeamViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation NPAddTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.teamService = [NPTeamService sharedService];

    CALayer *layer = [self.imageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:35.0];
}

- (IBAction)addButtonTapped:(id)sender {
    if (self.teamNameTextField.text == nil || self.teamNameTextField.text.length == 0) {
        return;
    }

    NSData *data = nil;
    NSString *imageData = nil;
    if (self.imageView.image != nil) {
        UIImage *image = self.imageView.image;
        data = UIImagePNGRepresentation(image);
        imageData = [data base64EncodedString];
    }

    NSDictionary *team = @{
                           @"name"  : self.teamNameTextField.text,
                           @"type"  : @"construction",
                           @"imageData" : imageData
                           };

    __weak NPAddTeamViewController *weakSelf = self;
    [self.teamService addItem:team completion:^(NSUInteger index) {
        weakSelf.teamNameTextField.text = @"";
        weakSelf.imageView.image = nil;

        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}


- (IBAction)addImageButtonTapped:(id)sender {
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

    self.imageView.image = small;

    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
