"Lispにおけるシンボルの型です"
struct Sym <: Object
    symbol::Symbol
end

function show(io::IO, e::Sym)
  print(io, e.symbol)
end

value(e::Sym) = e.symbol

symbol(name::String) = Sym(Symbol(name))

const NIL = symbol("nil")
const T = symbol("T")
const F = symbol("F")
const QUOTE = symbol("quote")
const END_OF_EXPRESSION = symbol("*end-of-expression*")
