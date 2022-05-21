"Lispにおけるシンボルの型です"
struct Sym <: Object
    symbol::Symbol
end

show(io::IO, e::Sym) = print(io, e.symbol)

symbol(name::String) = Sym(Symbol(name))

const NIL = symbol("nil")
const T = symbol("#t")
const F = symbol("#f")
const QUOTE = symbol("quote")
const END_OF_EXPRESSION = symbol("*end-of-expression*")
