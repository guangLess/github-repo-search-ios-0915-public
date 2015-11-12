//
//  FISReposTableViewController.m
//  Created by Joe Burgess on 5/5/14.
//
//

#import "FISReposTableViewController.h"
#import "FISSearchViewController.h"
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

}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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

#pragma mark alertView

-(IBAction)searchAlert:(UIBarButtonItem *)sender {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Search☀︎☉☔︎☁︎☼🌩" preferredStyle:UIAlertControllerStyleAlert];
    __block NSString * searchString;
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedString(@"searchPlaceholder", @"search");
    }];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        searchString = alertController.textFields.firstObject.text;
        NSLog(@"catchStringTest %@", searchString);
        [self performSearchonGithuWithString:searchString];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)performSearchonGithuWithString :(NSString *)stringName
{
    FISReposDataStore * dataStore =[FISReposDataStore sharedDataStore];
    [dataStore searchRepo:stringName withBlock:^(BOOL loadSearch) {
        if (loadSearch == YES) {
            NSLog(@"all the searched results %@ count %lu =",[dataStore.repositories[1] fullName],dataStore.repositories.count);
            [self.tableView reloadData];
        }
    }];
}

-(void)alertViewActiveWithStartMessage: (NSString *)starMessage{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:starMessage message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

#pragma mark searchVC

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    FISSearchViewController * searchVC = segue.destinationViewController;
    
}
@end
