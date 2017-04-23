# TODO:
#
# 1. use a Trie instead of dual object/array
# 2. allow partial string replacement via "prefix" using the Trie
# 3. ...

# use in add() to flatten an args array
flatten = require '@flatten/array'

class Unstring

  constructor: (options) ->

    # use default restrictions unless options has them.
    @min   = options?.min ? 1
    @max   = options?.max ? Infinity
    @limit = options?.limit ? Infinity
    @bytes = options?.bytes ? Infinity

    # remember how many bytes we have.
    @bytesCount = 0

    # store our strings info in an array for restring(id)
    @array = flatten options?.strings ? []
    # and in an object for string(string).
    @map = Object.create null

    # if we received strings via an array,
    # then add them into the map, too.
    @map[string] = index for string, index in @array

    # TODO: ensure `@map` is in fast mode.


  add1: (string, byteLength) ->
    index         = @array.length
    @array[index] = string
    @map[string]  = index
    @bytesCount  += byteLength ? Buffer.byteLength string
    return index


  add: ->
    # optimization friendly method
    args = new Array arguments.length
    args[i] = arguments[i] for i in [0 ... arguments.length]
    args = flatten args
    @add1 string for string in args
    return


  # true if string is known.
  has: (string) -> @map[string]?


  # return the id for this string, or null.
  # if unknown and unable to learn then return false.
  string: (string) ->

    id = @map[string]

    if id? then return id

    # instead, figure out if we should learn it

    # is there room within the `limit` ?
    if @array.length + 1 > @limit then return false

    # is the string within the `min` and `max` limits?
    length = string.length
    unless @min <= length <= @max then return false

    # will the string fit within the `bytes` limit?
    bytes = Buffer.byteLength string
    if @bytesCount + bytes > @bytes then return false

    # it's acceptable, so, learn it.
    # provide byte length as well so it doesn't have to
    # calculate it again.
    @add1 string, length


  # return the string for this id, or null.
  restring: (id) -> @array[id]


# export a function which creates an instance
module.exports = (options) -> new Unstring options

# export the class as a sub property on the function
module.exports.Unstring = Unstring
