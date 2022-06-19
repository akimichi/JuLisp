module JuLisp

import Base.==, Base.show, Base.get, Base.Iterators

export null, atom
export NIL, T, F, QUOTE
export symbol, Sym
export cons, car, cdr, list
export emptyEnv, defaultEnv, get, define, set
export special, procedure, evaluate
export closure
export LispReader, lispRead, repl
export Num, number
export Str, str
export value
export parser, interpret
export mkString

"Lispオブジェクトの抽象型です"
abstract type Object
end


"Apply可能なLispオブジェクトの型です"
struct Applicable <: Object
    apply::Function
end

special(f::Function) = Applicable(f)

"Lispの関数を作成する関数です"
function procedure(f::Function)
    Applicable((this, args, env) -> f(evlis(args, env)))
end



include("./symbol.jl")
include("./pair.jl")
include("./environment.jl")
include("./closure.jl")
include("./evaluate.jl")
include("./num.jl")
include("./str.jl")
include("./date.jl")
include("./parser.jl")


function null(e::Object)
  if e == NIL
    true
  else
    false
  end
end
atom(e::Sym) = true
atom(exp::Num) = true
atom(exp::Str) = true
atom(e::Pair) = false

function list(args::Object...)
    r = NIL
    for e in reverse(args)
        r = Pair(e, r)
    end
    return r
end

function list(args::Array{Object})
    r = NIL
    for e in reverse(args)
        r = Pair(e, r)
    end
    return r
end



function define(env::Env, variable::Sym, value::Object)
    env.bindings = Pair(Pair(variable::Sym, value), env.bindings) 
    return value
end




predicate(e::Bool) = e ? T : F

is_true(exp) = !(exp == F)
is_false(exp) = (exp == F)

include("./repl.jl")
include("./interpreter.jl")

end # module
