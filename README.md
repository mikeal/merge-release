## merge-release

GitHub Action for automated npm publishing.

This Action publishes a package to npm. It is meant to be used on every successful merge to master but 
you'll need to configure that workflow yourself. You can look to the
[`.github/workflows/push.yml`](./.github/workflows/push.yml) file in this project as an example.

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
* Push a tag for the new version to GitHub.

### Additional Configuration

* If your `package.json` is not in the repo's root directory, set `PACKAGE_PATH` env variable and the publish commands will be run from that package directory.
  ```
  - name: Publish
      uses: mikeal/merge-release@master
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        NPM_AUTH_TOKEN: ${{ secrets.NPM_AUTH_TOKEN }}
        PACKAGE_PATH: ./packages/my-package
  ```