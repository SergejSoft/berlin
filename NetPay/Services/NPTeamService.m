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

@property (nonatomic, strong)   MSTable *table;
@property (nonatomic)           NSInteger busyCount;

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

-(NPTeamService *)init {
    self = [super init];

    if (self) {
        // Initialize the Mobile Service client with your URL and key
        self.client = [MSClient clientWithApplicationURLString:@"https://net-pay.azure-mobile.net/"
                                                applicationKey:@"ulFzFpCbypfvUqRBUVmYkDjfecIlwR29"];

        // Add a Mobile Service filter to enable the busy indicator
        self.client = [self.client clientWithFilter:self];

        // Create an MSTable instance to allow us to work with the TodoItem table
        self.table = [_client tableWithName:NPTableNameTeams];

        self.teams = [[NSMutableArray alloc] init];
        self.busyCount = 0;
    }

    return self;
}

- (void)refreshDataOnSuccess:(NPCompletionBlock)completion {
    // Create a predicate that finds items where complete is false
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"complete == NO"];

    // Query the TodoItem table and update the items property with the results from the service
    [self.table readWithPredicate:predicate completion:^(NSArray *results, NSInteger totalCount, NSError *error) {
         [self logErrorIfNotNil:error];

         self.teams = [results mutableCopy];

         // Let the caller know that we finished
         completion();
     }];
}

- (void)addItem:(NSDictionary *)item completion:(NPCompletionWithIndexBlock)completion {
    // Insert the item into the TodoItem table and add to the items array on completion
    [self.table insert:item completion:^(NSDictionary *result, NSError *error) {
         [self logErrorIfNotNil:error];

         NSUInteger index = [self.teams count];
         [(NSMutableArray *)self.teams insertObject:result atIndex:index];

         // Let the caller know that we finished
         completion(index);
     }];
}

- (void)logErrorIfNotNil:(NSError *) error {
    if (error) {
        NSLog(@"ERROR %@", error);
    }
}

- (void)busy:(BOOL)busy {
    // assumes always executes on UI thread
    if (busy) {
        if (self.busyCount == 0 && self.busyUpdate != nil) {
            self.busyUpdate(YES);
        }
        self.busyCount ++;
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
