## merge-release

GitHub Action for automated npm publishing.

This Action publishes a package to npm. It is meant to be used on every successful merge to master but 
you'll need to configured that workflow yourself. You can look to the `.github/main.workflow` file in this
project as an example.

### Workflow

* Check for the latest version number published to npm.
* Lookup all commits between the git commit that triggered the action and the latest publish.
  * If the package hasn't been published or the prior publish does not include a git hash, we'll
    only pull the commit data that triggered the action.
* Based on the commit messages, increment the version from the lastest release.
  * If the string "BREAKING CHANGE" is found anywhere in any of the commit messages or descriptions the major 
    version will be incremented.
  * If a commit message begins with the string "feat" then the minor version will be increased. This works
    for most common commit metadata for feature additions: `"feat: new API"` and `"feature: new API"`.
  * All other changes will increment the patch version.
* Publish to npm using the configured token.
