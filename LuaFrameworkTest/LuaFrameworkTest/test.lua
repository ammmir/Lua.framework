function hello(s)
  print("hello " .. s)
end

function test(foo, bar, baz)
  res = {}
  table.insert(res, foo)
  table.insert(res, bar)
  res['baz'] = baz
  return res
end