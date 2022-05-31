using ParserCombinator

integer_number = PInt64() > Num
float_number = PFloat64() > Num
num = integer_number | float_number
word = Word()
string_token = E"\"" + word + E"\"" > Str
atom_token = num | string_token
exp = atom_token + Eos()


function parser(s::String)
  parse_one(s, exp)[1]
end
