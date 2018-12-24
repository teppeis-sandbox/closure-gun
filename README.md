# @teppeis/closure-gun

[![NPM version][npm-image]][npm-url]

This gets around the long startup time of [Google Closure Compiler](https://developers.google.com/closure/compiler/) using [Nailgun](https://github.com/facebook/nailgun), which runs a single java process in the background and keeps all of the classes loaded.

## Installation:

- Required: Java and Python
- Supported environment: macOS and Linux

```sh
$ npm install @teppeis/closure-gun
```

## Usage:

Execute Closure Compiler (start closure-gun server if not started)

```sh
$ closure-gun --js script.js --js_output_file script.min.js
```

Stop closure-gun server

```sh
$ closure-gun-stop
```

#### closure-gun (fork fast-closure-compiler2) vs. fast-closure-compiler:

Folked because the original [fast-closure-compiler](https://github.com/evanw/fast-closure-compiler) is not maintained.

The advantages are:

- Support latest Closure Compiler and Nailgun
- Support OS X 10.9+ (tested 10.10/10.11)
- Support Linux environment in addition to OS X
- Expose `closure-gun` as global command instead of `closure`

## License:

[The MIT License (MIT)](http://denji.mit-license.org/)

## Author:

- Teppei Sato <teppeis@gmail.com>
- Denis Denisov <denji@users.noreply.github.com>

[npm-image]: https://img.shields.io/npm/v/@teppeis/closure-gun.svg
[npm-url]: https://npmjs.org/package/@teppeis/closure-gun
