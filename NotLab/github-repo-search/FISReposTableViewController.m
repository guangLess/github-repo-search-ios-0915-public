//
//  FISReposTableViewController.m
//  
//
//  Created by Joe Burgess on 5/5/14.
//
//

#import "FISReposTableViewController.h"
#import "FISReposDataStore.h"
#import "FISGithubRepository.h"
#import "FISGithubAPIClient.h"

@interface FISReposTableViewController ()
@property (strong, nonatomic) FISReposDataStore *dataStore;
@end

@implementation FISReposTableViewController

-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.accessibilityLabel=@"Repo Table View";
    self.tableView.accessibilityIdentifier=@"Repo Table View";

    self.tableView.accessibilityIdentifier = @"Repo Table View";
    self.tableView.accessibilityLabel=@"Repo Table View";
    
    self.dataStore = [FISReposDataStore sharedDataStore];
    [self.dataStore getRepositoriesWithCompletion:^(BOOL success) {
        [self.tableView reloadData];
    }];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataStore.repositories count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basicCell" forIndexPath:indexPath];

    FISGithubRepository *repo = self.dataStore.repositories[indexPath.row];
    cell.textLabel.text = repo.fullName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    FISGithubRepository * pickedRepo = self.dataStore.repositories[indexPath.row];
    
    [FISReposDataStore checkEachRepo:pickedRepo.fullName withBlock:^(BOOL checkRepo) {
        if (checkRepo == YES){
            [FISGithubAPIClient starsOrDeleteARepoFrom:pickedRepo.fullName withApiAction:@"DELETE" inAcompletionBlock:^ (NSUInteger statusCode)
            {
                if (statusCode == 204 ){
                [self alertViewActiveWithStartMessage:@"unStared this Repo"];
                }
            }];
        }
        
        if (checkRepo == NO){
            [FISGithubAPIClient starsOrDeleteARepoFrom:pickedRepo.fullName withApiAction:@"PUT"  inAcompletionBlock:^ (NSUInteger statusCode)
            {
                if (statusCode == 204 ){
                [self alertViewActiveWithStartMessage:@"Stared this Repo"];
                }
            }];
        }
    }];
    
    NSLog(@"HELLO you select me");     
}

-(void)alertViewActiveWithStartMessage: (NSString *)starMessage{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:starMessage message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

@end
