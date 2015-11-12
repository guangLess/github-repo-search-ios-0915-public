//
//  FISSearchViewController.m
//  github-repo-starring
//
//  Created by Guang on 11/12/15.
//  Copyright © 2015 Joe Burgess. All rights reserved.
//

#import "FISSearchViewController.h"
#import "FISReposDataStore.h"
#import "FISGithubAPIClient.h"
// just for testing Do not do it otherwise
//#import "FISReposTableViewController.h"

@interface FISSearchViewController ()
@property (weak, nonatomic) IBOutlet UITextField *searchRepoString;

@end

@implementation FISSearchViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






-(IBAction)searchAction:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString * toSearchRepo = self.searchRepoString.text;
    
    FISReposDataStore * dataStore =[FISReposDataStore sharedDataStore];
    
    [dataStore searchRepo:toSearchRepo withBlock:^(BOOL loadSearch) {
        if (loadSearch == YES) {
         NSLog(@"all the searched results %@ count %lu =",[dataStore.repositories[1] fullName],dataStore.repositories.count);
//            FISReposTableViewController * tvc = [FISReposTableViewController new];
//            [tvc.tableView reloadData];
        }
    }];

}

@end
