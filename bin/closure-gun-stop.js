#!/usr/bin/env node

'use strict';

const path = require('path');
const child_process = require('child_process');

const ng = path.resolve(__dirname, '../nailgun/ng');
const compiler = child_process.spawn(ng, ['ng-stop'], {stdio: 'inherit'});
compiler.on('error', e => {
  console.error(e);
});
compiler.on('close', code => {
  process.exit(code);
});
