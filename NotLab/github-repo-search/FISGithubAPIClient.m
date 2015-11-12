//
//  FISGithubAPIClient.m
//  github-repo-list
//
//  Created by Joe Burgess on 5/5/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISGithubAPIClient.h"
#import "FISConstants.h"
#import <AFNetworking.h>

@implementation FISGithubAPIClient
NSString *const GITHUB_API_URL=@"https://api.github.com";

+(void)getRepositoriesWithCompletion:(void (^)(NSArray *))completionBlock
{
    NSString *githubURL = [NSString stringWithFormat:@"%@/repositories?client_id=%@&client_secret=%@",GITHUB_API_URL,GITHUB_CLIENT_ID,GITHUB_CLIENT_SECRET];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:githubURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Fail: %@",error.localizedDescription);
    }];
}

+(void)checkIfStarred:(NSString *)fullname checkFullNameWithBlock:(void(^) (BOOL))starredBlock{

    //__block NSString * x = @"";
    NSString * starRequest = [NSString stringWithFormat:@"%@/user/starred/%@?client_id=%@&client_secret=%@&access_token=%@",GITHUB_API_URL,fullname,GITHUB_CLIENT_ID,GITHUB_CLIENT_SECRET,GITHUB_ACCESS_TOKEN];
    
    NSURL * startURL = [NSURL URLWithString:starRequest];
    NSURLRequest * request = [NSURLRequest requestWithURL:startURL];
    NSURLSession * urlSession = [NSURLSession sharedSession];

    NSURLSessionDataTask * task = [ urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
        
        if (httpResponse.statusCode == 204){
            NSLog(@"repos already stared");
            starredBlock(YES);
        
        } if (httpResponse.statusCode == 404) {
            NSLog(@"repos not YET stared");
            starredBlock(NO);
        }
    }];
    
    [task resume];
}

+(void)starsOrDeleteARepoFrom:(NSString *)fullname withApiAction:(NSString *)apiAction inAcompletionBlock:(void (^) (NSUInteger)) statusCode{

    NSString * starString = [NSString stringWithFormat:@"%@/user/starred/%@?client_id=%@&client_secret=%@&access_token=%@",GITHUB_API_URL,fullname,GITHUB_CLIENT_ID,GITHUB_CLIENT_SECRET,GITHUB_ACCESS_TOKEN];
    
    NSURL * startURL = [NSURL URLWithString:starString];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL: startURL];

    request.HTTPMethod = apiAction;
    
    NSURLSession * urlSession = [NSURLSession sharedSession];

    NSURLSessionDataTask * starTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
        NSString * dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Check for stars. status code is %lu; JSON :%@", httpResponse.statusCode, dataString);

        statusCode(httpResponse.statusCode);
    }];
    
    [starTask resume];
}

@end
