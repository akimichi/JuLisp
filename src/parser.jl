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

# (define (foldr-1 fn xs init)
#   (if (null? xs)
#      init 
#       (fn (foldr-1 fn (cdr xs) init) (car xs))))
# 
function foldr(constructor::Pair, xs::Array{Object}, init::Object) 
      if isempty(xs) 
        return init
      else
        constructor(foldr(constructor, xs[2:end], init), xs[1])
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
array_token = Delayed()
sequence = Delayed()
integer_number = PInt64() > Num
float_number = PFloat64() > Num
num_token = integer_number | float_number
string_token = E"\"" + Word() + E"\"" > Str
symbol_token = identifier
date_token = E"@" + p"\d+-\d+-\d+" |> args -> date(String(join(args)))
atom_token = num_token | string_token | symbol_token | date_token
# quoted_symbol = E"'" + symbol_token |> args -> list(QUOTE, args[1])
quoted_symbol = E"'" + symbol_token |> args -> cons(QUOTE, args[1])
quoted_sequence = E"'" + sequence |> args -> cons(QUOTE, args[1])
quoted_exp = quoted_symbol | quoted_sequence
# expression = (atom_token | quoted_exp | sequence)
expression = (sequence | quoted_exp | atom_token)
items = Repeat(expression+ spc) |> args -> convert(Array{Object}, args)
sequence_prefix = E"(" + items
sequence_postfix = E")"  |> args -> NIL
dotted_pair_postfix = E"." + spc + expression + spc + E")" |> args -> args[1]
dotted_pair = sequence_prefix + dotted_pair_postfix |> args -> makeList(args[1], args[2])
# dotted_pair = E"(" + spc + items + spc + E"." + spc + expression + spc + E")" |> args -> makeList(args[1], args[2])
# dotted_pair = E"(" + spc + items + spc + E"." + spc + expression + spc + E")" |> args -> foldr(Pair,args[1], args[2])
list_token.matcher = sequence_prefix + sequence_postfix |> args -> makeList(args[1],NIL)
# list_token.matcher = E"(" + items + E")" |> args -> makeList(args[1],NIL)
sequence.matcher = sequence_prefix + (dotted_pair_postfix | sequence_postfix) |> args -> makeList(args[1],args[2])
# sequence.matcher = dotted_pair | list_token
sentence.matcher = expression + Eos()


function parser(s::String)
  parse_one(s, sentence)[1]
end
function parser(rule, s::String)
  parse_one(s, rule)[1]
end
