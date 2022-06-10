using ParserCombinator

export parse_rule
export num, string_token,symbol_token, list_token, items, quoted_exp, quoted_symbol, expression

function makeList(elements::Array{Object, 1}, last::Object)
    if last == NIL
        list(elements...)
    else
        for e in reverse(elements)
            last = Pair(e, last)
        end
        return last
    end
end


spc = Drop(Star(Space()))

@with_pre spc begin
  exp = Delayed()
  list_token = Delayed()
  integer_number = PInt64() > Num
  float_number = PFloat64() > Num
  num = integer_number | float_number
  word = Word()
  string_token = E"\"" + word + E"\"" > Str
  symbol_token = word |> args -> Sym(Symbol(args[1]))
  atom_token = num | string_token | symbol_token
  list_token = Delayed()
  quoted_symbol = E"'" + symbol_token |> args -> Pair(QUOTE, args[1])
  quoted_list = E"'" + list_token |> args -> list(QUOTE, args[1])
  quoted_exp = quoted_symbol | quoted_list
  expression = (atom_token | quoted_exp | list_token)
  items = Repeat(expression) |> args -> convert(Array{Object}, args)
  # items = Repeat(spc+num) |> args -> convert(Array{Object}, args)
  # dotted_pair = E"(" + exp   + E")" |> args -> list(args[1])
  list_token.matcher = E"(" + items + E")" |> args -> makeList(args[1],NIL)
  # list_token = E"(" + Repeat(expression) + E")" |> args -> makeList(args[1],NIL)
  exp.matcher = (atom_token | quoted_exp | list_token) + Eos()
end


function parser(s::String)
  parse_one(s, exp)[1]
end
function parser(rule, s::String)
  parse_one(s, rule)[1]
end
