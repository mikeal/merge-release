## merge-release

GitHub Action for automated npm publishing.

This Action publishes a package to npm. It is meant to be used on every successful merge to master but 
you'll need to configure that workflow yourself. You can look to the
[`.github/workflows/push.yml`](./.github/workflows/mikeals-workflow.yml) file in this project as an example.

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


### Configuration

You can configure some aspects of merge-release action by passing some environmental variables.

* **GITHUB_TOKEN (required)**
  * Github token to allow tagging the version.
* **NPM_AUTH_TOKEN (required)**
  * NPM Auth Token to publish to NPM, read [here](https://docs.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets) how to setup it as a secret.
* **DEPLOY_DIR**
  * The path where the dist `package.json` is to run npm publish. Defaults to the root dir.
* **SRC_PACKAGE_DIR**
  * The path where the src package.json is found. Defaults to the root dir.
* **NPM_REGISTRY_URL**
  * NPM Registry URL to use. defaults to: `https://registry.npmjs.org/`

`merge-release` will use `npm publish` unless you've defined a `publish` script in your `package.json`.

```yaml
- uses: mikeal/merge-release@master
  env:
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      NPM_AUTH_TOKEN: ${{ secrets.NPM_AUTH_TOKEN }}
      DEPLOY_DIR: my/deploy/dir
      SRC_PACKAGE_DIR: my/src/package
```
