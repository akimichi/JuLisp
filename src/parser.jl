using ParserCombinator

num = PInt64() > Num
exp = num + Eos()


function parser(s::String)
  parse_one(s, exp)[1]
end
