//
//  NPEmployeeService.m
//  NetPay
//
//  Created by Jurre Stender on 17/11/13.
//  Copyright (c) 2013 NetPay. All rights reserved.
//

#import "NPEmployeeService.h"

static NSString *const NPTableNameEmployees = @"Employees";

@interface NPEmployeeService () <MSFilter>

@end

@implementation NPEmployeeService

+ (instancetype)sharedService {
    static NPEmployeeService *_sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedService = [[NPEmployeeService alloc] init];
    });

    return _sharedService;
}

- (NPEmployeeService *)init {
    self = [super init];

    if (self) {
        [self setupClient];
        _employees = [[NSMutableArray alloc] init];
        self.table = [self.client tableWithName:NPTableNameEmployees];
    }
    
    return self;
}

- (void)refreshDataForTeamId:(NSInteger)teamId WithCompletion:(NPCompletionBlock)completion {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"teamId = %d", teamId];

    [self.table readWithPredicate:predicate completion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        [self logErrorIfNotNil:error];

        self.employees = [items mutableCopy];

        completion();
    }];
}

- (void)addItem:(NSDictionary *)item completion:(NPCompletionWithIndexBlock)completion {
    [self.table insert:item completion:^(NSDictionary *result, NSError *error) {
        [self logErrorIfNotNil:error];

        self.employees = [self.employees arrayByAddingObject:result];

        // Let the caller know that we finished
        completion(self.employees.count);
    }];
}

@end
