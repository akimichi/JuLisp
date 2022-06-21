using ParserCombinator

export parse_rule
export initial, subsequent, identifier, letter,digit, prefix, num_token, string_token, date_token, symbol_token, list_token, items, quoted_exp, quoted_symbol, expression, dotted_pair, quoted_sequence, sequence
export makeList 

function foldr(constructor, xs::Array{Object}, init::Object) 
      if isempty(xs) 
        return init
      else
        constructor(xs[1], foldr(constructor, xs[2:end], init))
      end
end
function makeList(elements::Array{Object, 1}, last::Object)
  return foldr(cons, elements, last)
#     if last == NIL
#         list(elements...)
#     else
#         for e in reverse(elements)
#             println("e: $e")
#             last = Pair(e, last)
#         end
#         return last
#     end
end


function dottedPairPostfixTransformer(args)
  @info "dottedPairPostfixTransformer: $(args[1])" 
  return args[1]
end

function sequenceTransformer(args) 
  if args[2] == NIL
    return list(args[1]) # return makeList(args[1],args[2])
  else
    @info "args[2]: $(mkString(args[2]))"
    @info "args[1]: $(args[1])"
    @info "args[1][1]: $(args[1][1])"
    if args[1] isa Array
      @info "args[1] isa Array"
      return  makeList(args[1],args[2])
      # result = makeList(args[1],args[2])
      # @info "result: $(mkString(result))"
      # return result
    else 
      return cons(args[1],args[2])
    end
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
# list_token = Delayed()
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
# quoted_sequence = E"'" + sequence |> args -> list(QUOTE, args[1])
quoted_sequence = E"'" + sequence |> args -> cons(QUOTE, args[1])
quoted_exp = quoted_symbol | quoted_sequence
expression = (atom_token | sequence | quoted_exp)
items = Repeat(expression + spc) |> args -> convert(Array{Object}, args)
sequence_prefix = E"(" + items
# dotted_pair_postfix = E"." + spc + expression + spc + E")" 
dotted_pair_postfix = E"." + spc + expression + spc + E")" |> args -> dottedPairPostfixTransformer(args)

dotted_pair = sequence_prefix + dotted_pair_postfix |> args -> makeList(args[1], args[2])
list_postfix = E")"  |> args -> NIL
sequence.matcher = sequence_prefix + (dotted_pair_postfix | list_postfix) |> args -> sequenceTransformer(args)
# sequence.matcher = sequence_prefix + (dotted_pair_postfix | list_postfix) |> args -> makeList(args[1],args[2])
# sequence.matcher = dotted_pair | list_token
# list_token.matcher = sequence_prefix + list_postfix |> args -> makeList(args[1],NIL)
# list_token.matcher = E"(" + items + E")" |> args -> makeList(args[1],NIL)
sentence.matcher = expression + Eos()


function parser(s::String)
  parse_one(s, sentence)[1]
end
function parser(rule, s::String)
  parse_one(s, rule)[1]
end
