//
//  NPTeamService.h
//  NetPay
//
//  Created by Jurre Stender on 16/11/13.
//  Copyright (c) 2013 NetPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NPBaseService.h"

@interface NPTeamService : NPBaseService

@property (nonatomic, strong) NSArray *teams;

+ (NPTeamService *)sharedService;

- (void)refreshDataWithCompletion:(NPCompletionBlock)completion;

- (void)addItem:(NSDictionary *)item
     completion:(NPCompletionWithIndexBlock)completion;

@end
