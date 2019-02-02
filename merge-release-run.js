#!/usr/bin/env node
console.log(process.argv)

const fs = require('fs')
const path = require('path')
const { execSync } = require('child_process')

/* Configure git */

//fs.writeFileSync('git-credentials')
//execSync('git 

const event = JSON.parse(fs.readFileSync('/github/workflow/event.json').toString())

let messages = event.commits.map(commit => commit.message)

let version = 'patch'
if (messages.map(message => message.includes('BREAKING CHANGE')).includes(true)) {
  version = 'major' 
} else if (messages.map(message => message.toLowerCase().startsWith('feat')).includes(true)) {
  version = 'minor'
}

let pkg = require(path.join(process.cwd(), 'package.json'))
let current = execSync(`npm view ${pkg.name} version`).toString()
process.stdout.write(execSync(`npm version --allow-same-version=true --git-tag-version=false ${current} `))
let newVersion = execSync(`npm version --git-tag-version=false ${version}`).toString()
console.log(newVersion)
process.stdout.write(execSync(`npm publish --access=public`))
/*
process.stdout.write(execSync(`git tag -a ${newVersion} -m "Created by merge-release.\n\n##Changelog:\n${messages.join('\n')}"`))
process.stdout.write(execSync(`git push --tags`))
*/
// npm version minor && npm publish --access=public && git push --tags
