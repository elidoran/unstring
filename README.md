# unstring
[![Build Status](https://travis-ci.org/elidoran/unstring.svg?branch=master)](https://travis-ci.org/elidoran/unstring)
[![Dependency Status](https://gemnasium.com/elidoran/unstring.png)](https://gemnasium.com/elidoran/unstring)
[![npm version](https://badge.fury.io/js/unstring.svg)](http://badge.fury.io/js/unstring)
[![Coverage Status](https://coveralls.io/repos/github/elidoran/unstring/badge.svg?branch=master)](https://coveralls.io/github/elidoran/unstring?branch=master)

Configurable strings cache swaps between strings and their ID.

This package:

1. knows strings to replace instead of sending the whole string
2. can be pre-configured with strings
3. can learn strings on-the-fly
4. can limit the number of strings in its cache
5. can limit the bytes of strings stored in its cache
6. can limit by the size of a string, both minimum and maximum length

See packages:

1. [endeo](https://www.npmjs.com/package/endeo)
2. [enbyte](https://www.npmjs.com/package/enbyte)
3. [debyte](https://www.npmjs.com/package/debyte)


## Install

```sh
npm install unstring --save
```


## Usage


```javascript
// get the builder
var buildUnstring = require('unstring')

// build one and configure it
var unstring = buildUnstring({
  // by default, there are no limits.
  limit: 200,      // limit by *number* of strings
  bytes: 10 * 1024,// limit by bytes of all stored strings
  min: 4,          // min chars in string to learn it
  max: 100,        // avoid "learning" very long strings
  // which strings should it know already.
  // by default, it knows none.
  strings: [
    'key1', 'some value'
  ]
})

// get `id` for this string in this cache.
// we know from above it's the first string,
// so, its `id` is `0`.
var id = unstring.string('key1')

// an unknown string will be learned and its ID returned.
// this one will be learned.
// so, its `id` is `2` (the third string).
id = unstring.string('unknown')

// if it isn't allowed due to a limit, such as min length:
// this returns `false` because it can't be learned.
id = unstring.string('a')

// a string beyond the `max` will also be denied with `false`.
id = unstring.string('blah blah blah......imagine 101+ chars')

// if we'd already added 200 strings
// then this would be denied with a `false`.
id = unstring.string('the 201+ string() attempt')

// if the total bytes used by all the strings learned
// exceeded (10 * 1024) bytes (configured above)
// then this would be denied with `false`.
id = unstring.string('too many bytes learned')

// for all known strings it's possible to get the
// string back using its ID.
// if `id` was `1` then we'd get `'some value'`.
var string = unstring.restring(id)


// can teach it strings at any time,
// ignoring all restrictions,
// via `add1()` and `add()`.
unstring.add1('single string *only*')
unstring.add('one string')
unstring.add('or', 'multiple', 'strings')
unstring.add([ 'or', 'array', 'of', 'strings' ])

// test if a string is known:
unstring.has('key1') // returns `true`
unstring.has('some value') // returns `true`
unstring.has('unknown') // returns `true` (above...)
unstring.has('not this one') // returns false
```


# [MIT License](LICENSE)
