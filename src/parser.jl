using ParserCombinator

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
  quoted_symbol = E"'" + symbol_token |> args -> list(QUOTE, args[1])
  # items = Repeat(exp) |> args -> list(args)
  items = num |> args -> list(args[1])
  list_token = E"(" + spc + items + spc + E")"
  compound = quoted_symbol | list_token
  exp = (atom_token | compound ) + Eos()


  function parser(s::String)
    parse_one(s, exp)[1]
  end
end
