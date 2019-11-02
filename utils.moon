getKeys = (t) ->
  keys = {}
  for k, _ in pairs(t)
    table.insert(keys, k)
  keys

map = (t, f) ->
  result = {}
  for k, v in pairs(t)
    result[k] = f(v)
  result

filterWithIndex = (a, predicate) ->
  result = {}
  for i, v in ipairs(a)
    if predicate(i, v)
      table.insert(result, v)
  result

contains = (t, value) ->
  for k, v in pairs(t)
    if v == value
      return true
  false

stringGroup = (s, size) ->
  result = {}
  for i = 1, s\len!, size
    table.insert(result, s\sub(i, i + size - 1))
  result

reverse = (a) ->
  n = #a
  for i = 1, math.floor(n / 2)
    j = n - i + 1
    temp = a[i]
    a[i] = a[j]
    a[j] = temp
  a

hexStrToBinaryStr = (s) ->
  s\gsub("..", (cc) -> string.char(tonumber(cc, 16)))

{ :getKeys, :map, :filterWithIndex, :contains, :stringGroup, :reverse, :hexStrToBinaryStr }
