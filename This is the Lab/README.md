

# Star Github Repo

## Instructions

Before you start, set up your api keys (FISConstants.m) and make sure you can get the list of repos from the API into your tableview.

  1. Create the method in `FISGithubAPIClient` called `checkIfStarred:` that accepts a `full_name` to check and see if it is currently starred. Checkout the [Github Documentation](https://developer.github.com/v3/activity/starring/#check-if-you-are-starring-a-repository) on how this works on the API side.
  2. Make a method in `FISGithubAPIClient` that stars a repo given its `full_name`. Checkout the [Github Documentation](https://developer.github.com/v3/activity/starring/#star-a-repository)
  3. Make a method in `FISGithubAPIClient` that unstars a repo given its `full_name`. Checkout the [Github Documentation](https://developer.github.com/v3/activity/starring/#unstar-a-repository)
  4. Create a method in `FISReposDataStore` that given a `FISGithubRepository` object, will check to see if it's starred or not and then either star or unstar the repo. In the completionBlock, there should be a `BOOL` parameter called `starred` that is `YES` if the repo was just starred, and `NO` if it was just unstarred.
  5. When a cell is selected, it should call your `FISReposDataStore` method to toggle the starred status and display a `UIAlertController` saying either "You just starred <REPO NAME>" or "You just unstarred <REPO NAME>".
