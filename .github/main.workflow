workflow "Build and Publish" {
  on = "push"
  resolves = "Docker Publish"
}

action "Shell Lint" {
  uses = "actions/bin/shellcheck@master"
  args = "entrypoint.sh"
}

action "Docker Lint" {
  uses = "docker://replicated/dockerfilelint"
  args = ["Dockerfile"]
}

action "Build" {
  needs = ["Shell Lint", "Docker Lint"]
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

action "NPM Publish" {
  needs = "Publish Filter" {
  uses = "mikeal/merge-release@master"
  secrets = ["GITHUB_TOKEN", "NPM_AUTH_TOKEN"]
}
