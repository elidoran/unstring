assert = require 'assert'

buildUnstring = require '../../lib/index.coffee'

describe 'test unstring', ->

  it 'should build', -> assert buildUnstring()

  it 'should deny learning by default', ->

    unstring = buildUnstring()
    result = unstring.string 'test'
    assert.equal result, false

  it 'should build with strings options', ->
    array = [ 'one', 'two', 'three', 'four', 'five' ]
    unstring = buildUnstring strings:array
    assert.deepEqual unstring.array, array
    assert.deepEqual unstring.map,
      one: 0, two: 1, three: 2, four: 3, five: 4


  it 'should know if it has a string', ->
    unstring = buildUnstring strings:[ 'one', 'two', 'three' ]
    assert.equal unstring.has('one'), true
    assert.equal unstring.has('two'), true
    assert.equal unstring.has('three'), true
    assert.equal unstring.has('four'), false
    assert.equal unstring.has('1234'), false


  it 'should learn a string when instructed to via add1()', ->
    unstring = buildUnstring()
    assert.equal unstring.has('test'), false
    unstring.add1 'test'
    assert.equal unstring.has('test'), true


  it 'should learn string when instructed to via add()', ->
    unstring = buildUnstring()
    assert.equal unstring.has('test'), false
    unstring.add 'test'
    assert.equal unstring.has('test'), true


  it 'should learn strings when instructed to via add()', ->
    unstring = buildUnstring()
    assert.equal unstring.has('test'), false
    assert.equal unstring.has('test2'), false
    assert.equal unstring.has('test3'), false
    unstring.add 'test', 'test2', 'test3'
    assert.equal unstring.has('test'), true
    assert.equal unstring.has('test2'), true
    assert.equal unstring.has('test3'), true


  it 'should learn strings when instructed to via add()', ->
    unstring = buildUnstring()
    assert.equal unstring.has('test'), false
    assert.equal unstring.has('test2'), false
    assert.equal unstring.has('test3'), false
    unstring.add [ 'test', ['test2'], 'test3' ]
    assert.equal unstring.has('test'), true
    assert.equal unstring.has('test2'), true
    assert.equal unstring.has('test3'), true


  it 'should auto-learn an unknown string', ->
    unstring = buildUnstring limit: 1
    assert.equal unstring.has('unknown'), false
    assert.deepEqual unstring.string('unknown'), id:0, known:false
    assert.equal unstring.has('unknown'), true


  it 'should return id for known string', ->
    unstring = buildUnstring strings:[ 'one', 'two', 'three' ]
    assert.deepEqual unstring.string('two'), id:1, known:true


  it 'should return null for an unknown id', ->
    unstring = buildUnstring()
    assert.equal unstring.restring(2), null
    unstring.add1 'test'
    unstring.add1 'test2'
    assert.equal unstring.restring(2), null


  it 'should return a string for a known id', ->
    unstring = buildUnstring strings:[ 'one', 'two', 'three' ]
    assert.equal unstring.restring(0), 'one'
    assert.equal unstring.restring(1), 'two'
    assert.equal unstring.restring(2), 'three'


  describe 'will auto-learn a string', ->

    it 'when min allows', ->
      unstring = buildUnstring min: 2, limit: Infinity

      # won't accept
      assert.equal unstring.string(''), false
      assert.equal unstring.string('a'), false

      # will accept
      assert.deepEqual unstring.string('ab'), id:0, known:false
      assert.deepEqual unstring.string('abc'), id:1, known:false
      assert.deepEqual unstring.string('abcdefghi'), id:2, known:false


    it 'when max allows', ->
      unstring = buildUnstring max: 5, limit: Infinity

      # won't accept
      assert.equal unstring.string('1234567890'), false
      assert.equal unstring.string('123456'), false

      # will accept
      assert.deepEqual unstring.string('1234'), id:0, known:false
      assert.deepEqual unstring.string('123'), id:1, known:false
      assert.deepEqual unstring.string('12'), id:2, known:false


    it 'when limit allows', ->
      unstring = buildUnstring limit: 3

      # will accept
      assert.deepEqual unstring.string('one'), id:0, known:false
      assert.deepEqual unstring.string('two'), id:1, known:false
      assert.deepEqual unstring.string('three'), id:2, known:false

      # won't accept
      assert.equal unstring.string('a'), false
      assert.equal unstring.string('1'), false
      assert.equal unstring.string('full already'), false


    it 'when bytes allows', ->
      unstring = buildUnstring bytes: 12, limit: Infinity

      # will accept
      assert.deepEqual unstring.string('one'), id:0, known:false   # 3 bytes = 3 total
      assert.deepEqual unstring.string('two'), id:1, known:false   # 3 bytes = 6 total
      assert.deepEqual unstring.string('three'), id:2, known:false # 5 bytes = 11 total

      # won't accept
      assert.equal unstring.string('four'), false # 4 bytes would be 15 total. too much.

      # will accept
      assert.deepEqual unstring.string('a'), id:3, known:false  # 1 byte would be 12 total, allowed

      # wont accept
      assert.equal unstring.string('1'), false
      assert.equal unstring.string('full already'), false
