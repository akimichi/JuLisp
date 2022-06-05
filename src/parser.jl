using ParserCombinator

export parse_rule
export num

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
  #items = Star(spc+exp+spc) |> args -> list(args)
  items = exp |> args -> list(args[1])
  list_token = E"(" + spc + items + spc + E")"
  compound = quoted_exp
  exp = (atom_token | compound | list_token) + Eos()


  function parser(s::String)
    parse_one(s, exp)[1]
  end
  function parse_rule(rule, s::String)
    parse_one(s, rule)[1]
  end
end
