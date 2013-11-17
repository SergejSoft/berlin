//
//  NPBaseService.h
//  NetPay
//
//  Created by Jurre Stender on 17/11/13.
//  Copyright (c) 2013 NetPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

typedef void (^NPCompletionBlock) ();
typedef void (^NPCompletionWithIndexBlock) (NSUInteger index);
typedef void (^NPBusyUpdateBlock) (BOOL busy);

@interface NPBaseService : NSObject <MSFilter>

@property (nonatomic, strong)   MSTable *table;
@property (nonatomic)           NSInteger busyCount;

@property (nonatomic, strong)   MSClient *client;
@property (nonatomic, copy)     NPBusyUpdateBlock busyUpdate;

+ (MSUser *)currentUser;

- (void)logErrorIfNotNil:(NSError *) error;

- (void)setupClient;

- (void)handleRequest:(NSURLRequest *)request
                 next:(MSFilterNextBlock)next
             response:(MSFilterResponseBlock)response;

@end
