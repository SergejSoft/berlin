//
//  NPTeamService.m
//  NetPay
//
//  Created by Jurre Stender on 16/11/13.
//  Copyright (c) 2013 NetPay. All rights reserved.
//

#import "NPTeamService.h"

static NSString *const NPTableNameTeams = @"Teams";

@interface NPTeamService () <MSFilter>

@end

@implementation NPTeamService

+ (instancetype)sharedService {
    static NPTeamService *_sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedService = [[NPTeamService alloc] init];
    });

    return _sharedService;
}

- (NPTeamService *)init {
    self = [super init];

    if (self) {
        [self setupClient];
        self.table = [self.client tableWithName:NPTableNameTeams];
        _teams = [[NSMutableArray alloc] init];
    }

    return self;
}

- (void)refreshDataWithCompletion:(NPCompletionBlock)completion {
    [self.table readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        [self logErrorIfNotNil:error];

        self.teams = [items mutableCopy];

        completion();
    }];
}

- (void)addItem:(NSDictionary *)item completion:(NPCompletionWithIndexBlock)completion {
    [self.table insert:item completion:^(NSDictionary *result, NSError *error) {
         [self logErrorIfNotNil:error];

        self.teams = [self.teams arrayByAddingObject:result];

         // Let the caller know that we finished
         completion(self.teams.count);
     }];
}


@end
