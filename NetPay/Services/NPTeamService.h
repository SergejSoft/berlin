//
//  NPTeamService.h
//  NetPay
//
//  Created by Jurre Stender on 16/11/13.
//  Copyright (c) 2013 NetPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

typedef void (^NPCompletionBlock) ();
typedef void (^NPCompletionWithIndexBlock) (NSUInteger index);
typedef void (^NPBusyUpdateBlock) (BOOL busy);


@interface NPTeamService : NSObject

@property (nonatomic, strong)   NSArray *teams;
@property (nonatomic, strong)   MSClient *client;
@property (nonatomic, copy)     NPBusyUpdateBlock busyUpdate;

+ (NPTeamService *)sharedService;

- (void)refreshDataOnSuccess:(NPCompletionBlock)completion;

- (void)addItem:(NSDictionary *)item
     completion:(NPCompletionWithIndexBlock)completion;

- (void)handleRequest:(NSURLRequest *)request
                 next:(MSFilterNextBlock)next
             response:(MSFilterResponseBlock)response;

@end
