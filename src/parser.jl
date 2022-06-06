using ParserCombinator

export parse_rule
export num, string_token,symbol_token, list_token, items

spc = Drop(Star(Space()))

@with_pre spc begin
  exp = Delayed()
  integer_number = PInt64() > Num
  float_number = PFloat64() > Num
  num = integer_number | float_number
  word = Word()
  string_token = E"\"" + word + E"\"" > Str
  symbol_token = word |> args -> Sym(Symbol(args[1]))
  atom_token = num | string_token | symbol_token
  # quoted_symbol = E"'" + word |> args -> list(QUOTE, args[1])
  # quoted_list = E"'" + exp |> args -> list(QUOTE, args[1])
  quoted_exp = E"'" + exp |> args -> list(QUOTE, args[1])
  items = Repeat(spc+num) |> args -> convert(Array{Object}, args)
  # items = num
  list_token = E"(" + items + E")" |> args -> list(args[1])
  exp = (atom_token | quoted_exp | list_token) + Eos()
end


function parser(s::String)
  parse_one(s, exp)[1]
end
function parse_rule(rule, s::String)
  parse_one(s, rule)[1]
end
