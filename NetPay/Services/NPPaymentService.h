//
//  NPPaymentService.h
//  NetPay
//
//  Created by Jurre Stender on 17/11/13.
//  Copyright (c) 2013 NetPay. All rights reserved.
//

#import "NPBaseService.h"

@interface NPPaymentService : NPBaseService

+ (instancetype)sharedService;

- (void)addItem:(NSDictionary *)item
     completion:(NPCompletionBlock)completion;

@end
