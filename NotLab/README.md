

# github-repo-search

Let's do a bit more...let's let users search all of the github repos. Bring over stuff from your github-repo-starring lab and lets move forward. 

## Instructions

  1. Bring over your code from github-repo-starring
  2. Take a look at the [repo search documentation](https://developer.github.com/v3/search/#search-repositories) and implement the appropriate method to do a search for repositories
  3. Add a `UIBarButtonItem`. When a user taps the button, it should display a `UIAlertController` that asks what the user would like to search for. When they select Search perform the search and then display the updated list of repos. `UIAlertController` is new in iOS 8. [This](http://useyourloaf.com/blog/2014/09/05/uialertcontroller-changes-in-ios-8.html) is my favorite resource on it.
  4. Implement (and re-implement) all the networking stuff using AFNetworking.
  5. Starring and all that should still work!
