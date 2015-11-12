//
//  FISGithubAPIClient.h
//  github-repo-list
//
//  Created by Joe Burgess on 5/5/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *const GITHUB_API_URL;
@interface FISGithubAPIClient : NSObject



+(void)getRepositoriesWithCompletion:(void (^)(NSArray *repoDictionaries))completionBlock;
+(void)checkIfStarred:(NSString *)fullname checkFullNameWithBlock:(void(^) (BOOL))starredBlock; // do the starOrDeleteApo
+(void)starsOrDeleteARepoFrom:(NSString *)fullname withApiAction:(NSString *)apiAction inAcompletionBlock:(void (^) (NSUInteger)) statusCode;

@end
