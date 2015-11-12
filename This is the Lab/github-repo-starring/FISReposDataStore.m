//
//  FISReposDataStore.m
//  github-repo-list
//
//  Created by Joe Burgess on 5/5/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISReposDataStore.h"
#import "FISGithubAPIClient.h"
#import "FISGithubRepository.h"

@implementation FISReposDataStore
+ (instancetype)sharedDataStore {
    static FISReposDataStore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[FISReposDataStore alloc] init];
    });

    return _sharedDataStore;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _repositories=[NSMutableArray new];
    }
    return self;
}

-(void)getRepositoriesWithCompletion:(void (^)(BOOL))completionBlock
{
    [self.repositories removeAllObjects];
    [FISGithubAPIClient getRepositoriesWithCompletion:^(NSArray *repoDictionaries) {
        for (NSDictionary *repoDictionary in repoDictionaries) {
            [self.repositories addObject:[FISGithubRepository repoFromDictionary:repoDictionary]];
        }
        completionBlock(YES);
    }];
}

+(void)checkEachRepo: (NSString *)fullName withBlock:(void(^)(BOOL checkRepo))completionBlock{//block
    
    [FISGithubAPIClient checkIfStarred:fullName checkFullNameWithBlock:^(BOOL starredBlock)
     {
         completionBlock(starredBlock);
          if (starredBlock == YES) {
             NSLog(@"%@, is starred",fullName);
         }else {
             NSLog(@"%@, is not stared",fullName);
         }
     }];
}

-(void)searchRepo: (NSString *)repoName withBlock:(void (^)(BOOL loadSearch))comletionBlock{ // why?
    [self.repositories removeAllObjects];
    [FISGithubAPIClient searchRepo:repoName withBlock:^(NSArray *searcResults) {
        for (NSDictionary * eachResult in searcResults) {
            [self.repositories addObject: [FISGithubRepository repoFromDictionary:eachResult]];
        }
        comletionBlock(YES);
     }];
}

@end
