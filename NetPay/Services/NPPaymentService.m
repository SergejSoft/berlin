//
//  NPPaymentService.m
//  NetPay
//
//  Created by Jurre Stender on 17/11/13.
//  Copyright (c) 2013 NetPay. All rights reserved.
//

#import "NPPaymentService.h"

static NSString *const NPTableNamePayments = @"Payments";

@implementation NPPaymentService

+ (instancetype)sharedService {
    static NPPaymentService *_sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedService = [[NPPaymentService alloc] init];
    });

    return _sharedService;
}

- (NPPaymentService *)init {
    self = [super init];

    if (self) {
        [self setupClient];
        self.table = [self.client tableWithName:NPTableNamePayments];
    }

    return self;
}

- (void)addItem:(NSDictionary *)item
     completion:(NPCompletionBlock)completion {
    [self.table insert:item completion:^(NSDictionary *result, NSError *error) {
        [self logErrorIfNotNil:error];

        // Let the caller know that we finished
        completion();
    }];
}

@end
