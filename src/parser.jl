using ParserCombinator

export parse_rule
export initial, subsequent, identifier, letter,digit, prefix, num_token, string_token, date_token, symbol_token, list_token, items, quoted_exp, quoted_symbol, expression, dotted_pair, quoted_sequence, sequence

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

letter = p"[a-zA-Z]"
digit = p"[0-9]"
prefix = p"[+-\\*/^&~\|#]"
initial = prefix | letter
subsequent = initial | digit
postfix = p"[!?]" 
identifier = initial + Repeat(subsequent) + (postfix | ~e"") |> args -> Sym(Symbol(join(args)))

sentence = Delayed()
list_token = Delayed()
sequence = Delayed()
integer_number = PInt64() > Num
float_number = PFloat64() > Num
num_token = integer_number | float_number
string_token = E"\"" + Word() + E"\"" > Str
symbol_token = identifier
date_token = E"@" + p"\d+-\d+-\d+" > DateType
atom_token = num_token | string_token | symbol_token | date_token
quoted_symbol = E"'" + symbol_token |> args -> list(QUOTE, args[1])
quoted_sequence = E"'" + sequence |> args -> list(QUOTE, args[1])
quoted_exp = quoted_symbol | quoted_sequence
expression = (atom_token | quoted_exp | sequence)
items = Repeat(expression+ spc) |> args -> convert(Array{Object}, args)
dotted_pair = E"(" + spc + items + spc + E"." + spc + expression + spc + E")" |> args -> makeList(args[1],args[2])
list_token.matcher = E"(" + items + E")" |> args -> makeList(args[1],NIL)
sequence.matcher = dotted_pair | list_token
sentence.matcher = expression + Eos()


function parser(s::String)
  parse_one(s, sentence)[1]
end
function parser(rule, s::String)
  parse_one(s, rule)[1]
end
