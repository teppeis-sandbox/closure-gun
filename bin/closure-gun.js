#!/usr/bin/env node

'use strict';

const path = require('path');
const child_process = require('child_process');
const util = require('util');
const exec = util.promisify(child_process.exec);

let compilerPath = null;
try {
  // eslint-disable-next-line node/no-extraneous-require
  compilerPath = require('google-closure-compiler-java');
} catch (ignore) {
  try {
    compilerPath = require('google-closure-compiler').compiler.COMPILER_PATH;
  } catch (ignore) {
    console.error('google-closure-compiler is not found');
    console.error('Please `npm install google-closure-compiler`');
    process.exit(1);
  }
}

const serverPath = path.resolve(__dirname, '../nailgun/server.jar');
const server = [
  'java',
  '-server',
  '-cp',
  `${serverPath}:${compilerPath}`,
  'com.facebook.nailgun.NGServer',
].join(' ');

const ng = path.resolve(__dirname, '../nailgun/ng');
const cmd = 'com.google.javascript.jscomp.CommandLineRunner';
(async () => {
  const {stdout: ps} = await exec('ps x', {encoding: 'utf8'});
  if (!ps.includes(server)) {
    // Start nailgun server
    const ngserver = child_process.exec(`nohup ${server}`, (e, stdout, stderr) => {
      if (e) {
        console.error('Fail to start nailgun server');
        console.error(e.message);
        process.exit(e.code);
      }
    });

    // Wait for ready
    const TIMEOUT_MILLIS = 10 * 1000;
    const timeout = Date.now() + TIMEOUT_MILLIS;
    while (true) {
      if (Date.now() > timeout) {
        console.error('Timeout: fail to start nailgun server');
        ngserver.kill();
        process.exit(1);
      }
      try {
        const {stdout, stderr} = await exec([ng, cmd, '--', '--version'].join(' '));
        if (/Version/.test(stdout)) {
          break;
        } else {
          console.error('Unexpected result', stdout, stderr);
          process.exit(1);
        }
      } catch (e) {
        if (!/Could not connect to server/i.test(e.message)) {
          console.error(e.message);
          process.exit(e.code);
        }
        await wait(100);
      }
    }
  }

  // Execute command
  const args = [cmd, '--', ...process.argv.slice(2)];
  const compiler = child_process.spawn(ng, args, {stdio: 'inherit'});
  compiler.on('error', e => {
    console.error(e);
  });
  compiler.on('close', code => {
    process.exit(code);
  });
})();

function wait(ms) {
  return new Promise((res, rej) => {
    setTimeout(() => {
      res();
    }, ms);
  });
}
