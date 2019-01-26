#!/usr/bin/env node
const fs = require('fs')
const { execSync } = require('child_process')

const event = JSON.parse(fs.readFileSync('/github/workflow/event.json').toString())

let messages = event.commits.map(commit => commit.message)

let version = 'patch'
if (messages.map(message => message.includes('BREAKING CHANGE')).includes(true)) {
  version = 'major' 
} else if (messages.map(message => message.toLowerCase().startsWith('feat')).includes(true)) {
  version = 'minor'
}

let version = 'patch'

let pkg = require('./package.json')
let current = execSync(`npm view ${pkg.name} version`).toString()
process.stdout.write(execSync(`npm version --allow-same-version=true --git-tag-version=false ${current} `))
let newVersion = execSync(`npm version --git-tag-version=false ${version}`).toString()
console.log(newVersion)
process.stdout.write(execSync(`npm publish --access=public`))
process.stdout.write(execSync(`git tag -a ${newVersion} -m "Created by merge-release.\n\n##Changelog:\n${messages.join('\n')}"`))
process.stdout.write(execSync(`git push --tags`))

// npm version minor && npm publish --access=public && git push --tags
