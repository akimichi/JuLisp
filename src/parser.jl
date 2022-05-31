using ParserCombinator

integer_number = PInt64() > Num
float_number = PFloat64() > Num
num = integer_number | float_number
word = Word()
string_token = E"\"" + word + E"\"" > Str
symbol_token = word |> args -> Sym(Symbol(args[1]))
atom_token = num | string_token | symbol_token
quoted_symbol = E"'" + symbol_token |> args -> list(QUOTE, args[1])
compound = quoted_symbol
exp = (atom_token | compound ) + Eos()


function parser(s::String)
  parse_one(s, exp)[1]
end
