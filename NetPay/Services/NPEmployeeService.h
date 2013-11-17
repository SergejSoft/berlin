//
//  NPEmployeeService.h
//  NetPay
//
//  Created by Jurre Stender on 17/11/13.
//  Copyright (c) 2013 NetPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "NPBaseService.h"

typedef void (^NPCompletionBlock) ();
typedef void (^NPCompletionWithIndexBlock) (NSUInteger index);
typedef void (^NPBusyUpdateBlock) (BOOL busy);

@interface NPEmployeeService : NPBaseService

@property (nonatomic, strong)   NSArray *teams;
@property (nonatomic, strong)   MSClient *client;
@property (nonatomic, copy)     NPBusyUpdateBlock busyUpdate;

+ (NPEmployeeService *)sharedService;

- (void)refreshDataForTeamId:(NSInteger)teamId WithCompletion:(NPCompletionBlock)completion;

- (void)addItem:(NSDictionary *)item
     completion:(NPCompletionWithIndexBlock)completion;

@end
