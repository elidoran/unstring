assert = require 'assert'

buildUnstring = require '../../lib/index.coffee'

describe 'test unstring', ->

  it 'should build', -> assert buildUnstring()


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
    unstring = buildUnstring()
    assert.equal unstring.has('unknown'), false
    assert.equal unstring.string('unknown'), 0
    assert.equal unstring.has('unknown'), true


  it 'should return id for known string', ->
    unstring = buildUnstring strings:[ 'one', 'two', 'three' ]
    assert.equal unstring.string('two'), 1


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


  describe 'will learn a string', ->

    it 'when min allows', ->
      unstring = buildUnstring min: 2

      # won't accept
      assert.equal unstring.string(''), false
      assert.equal unstring.string('a'), false

      # will accept
      assert.equal unstring.string('ab'), 0
      assert.equal unstring.string('abc'), 1
      assert.equal unstring.string('abcdefghi'), 2


    it 'when max allows', ->
      unstring = buildUnstring max: 5

      # won't accept
      assert.equal unstring.string('1234567890'), false
      assert.equal unstring.string('123456'), false

      # will accept
      assert.equal unstring.string('1234'), 0
      assert.equal unstring.string('123'), 1
      assert.equal unstring.string('12'), 2


    it 'when limit allows', ->
      unstring = buildUnstring limit: 3

      # will accept
      assert.equal unstring.string('one'), 0
      assert.equal unstring.string('two'), 1
      assert.equal unstring.string('three'), 2

      # won't accept
      assert.equal unstring.string('a'), false
      assert.equal unstring.string('1'), false
      assert.equal unstring.string('full already'), false


    it 'when bytes allows', ->
      unstring = buildUnstring bytes: 12

      # will accept
      assert.equal unstring.string('one'), 0   # 3 bytes = 3 total
      assert.equal unstring.string('two'), 1   # 3 bytes = 6 total
      assert.equal unstring.string('three'), 2 # 5 bytes = 11 total

      # won't accept
      assert.equal unstring.string('four'), false # 4 bytes would be 15 total. too much.

      # will accept
      assert.equal unstring.string('a'), 3        # 1 byte would be 12 total, allowed

      # wont accept
      assert.equal unstring.string('1'), false
      assert.equal unstring.string('full already'), false
