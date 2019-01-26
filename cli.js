#!/usr/bin/env node
const fs = require('fs')
console.log(JSON.parse(fs.readFileSync('/github/workflow/event.json').toString()))
