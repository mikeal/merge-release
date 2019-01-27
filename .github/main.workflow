workflow "Build and Publish" {
  on = "push"
  resolves = ["Publish"]
}

action "Shell Lint" {
  uses = "actions/bin/shellcheck@master"
  args = "entrypoint.sh"
}

action "Build" {
  needs = ["Shell Lint"]
  uses = "actions/docker/cli@master"
  args = "build -t npm ."
}

action "Docker Tag" {
  needs = ["Build"]
  uses = "actions/docker/tag@master"
  args = "npm github/npm --no-latest"
}

action "Publish Filter" {
  needs = ["Build"]
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Publish" {
  needs = "Publish Filter"
  uses = "mikeal/merge-release@master"
  secrets = ["GITHUB_TOKEN", "NPM_AUTH_TOKEN"]
}
