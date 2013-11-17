//
//  NPBaseService.m
//  NetPay
//
//  Created by Jurre Stender on 17/11/13.
//  Copyright (c) 2013 NetPay. All rights reserved.
//

#import "NPBaseService.h"
#import <SSKeychain/SSKeychain.h>

@implementation NPBaseService

+ (MSUser *)currentUser {
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

- (void)logErrorIfNotNil:(NSError *) error {
    if (error) {
        NSLog(@"ERROR %@", error);
    }
}

- (void)setupClient {
    _client = [MSClient clientWithApplicationURLString:@"https://net-pay.azure-mobile.net/"
                                        applicationKey:@"ulFzFpCbypfvUqRBUVmYkDjfecIlwR29"];

    // Add a Mobile Service filter to enable the busy indicator
    _client = [self.client clientWithFilter:self];
    _client.currentUser = [NPBaseService currentUser];

    _busyCount = 0;
}

- (void)busy:(BOOL)busy {
    if (busy) {
        if (self.busyCount == 0 && self.busyUpdate != nil) {
            self.busyUpdate(YES);
        }
        self.busyCount++;
    } else {
        if (self.busyCount == 1 && self.busyUpdate != nil) {
            self.busyUpdate(FALSE);
        }
        self.busyCount--;
    }
}

#pragma mark * MSFilter methods


- (void)handleRequest:(NSURLRequest *)request
                 next:(MSFilterNextBlock)next
             response:(MSFilterResponseBlock)response
{
    // A wrapped response block that decrements the busy counter
    MSFilterResponseBlock wrappedResponse = ^(NSHTTPURLResponse *innerResponse, NSData *data, NSError *error) {
        [self busy:NO];
        response(innerResponse, data, error);
    };

    // Increment the busy counter before sending the request
    [self busy:YES];
    next(request, wrappedResponse);
}

@end
