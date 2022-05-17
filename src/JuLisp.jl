module JuLisp

import Base.==, Base.show, Base.get, Base.Iterators

export null, atom
export NIL, T, QUOTE
export symbol
export cons, car, cdr, list
export emptyEnv, defaultEnv, get, define, set
export special, procedure, evaluate
export closure
export LispReader, lispRead, repl
export Num, number
export Str, string

"Lispオブジェクトの抽象型です"
abstract type Object
end


"Apply可能なLispオブジェクトの型です"
struct Applicable <: Object
    apply::Function
end


include("./symbol.jl")
include("./pair.jl")
include("./environment.jl")
include("./closure.jl")
include("./num.jl")
include("./str.jl")



null(e::Object) = e == NIL
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



function define(env::Env, variable::Sym, value::Object)
    env.bindings = Pair(Pair(variable::Sym, value), env.bindings) 
    return value
end


special(f::Function) = Applicable(f)

function evlis(args::Object, env::Env)
    args isa Pair ? Pair(evaluate(args.car, env), evlis(args.cdr, env)) : NIL 
end

"Lispの関数を作成する関数です"
function procedure(f::Function)
    Applicable((this, args, env) -> f(evlis(args, env)))
end

evaluate(variable::Sym, env::Env) = get(env, variable)

function evaluate(e::Pair, env::Env)
    closure = evaluate(e.car, env)
    closure.apply(closure, e.cdr, env)
end




predicate(e::Bool) = e ? T : NIL

function lispIf(s::Applicable, a::Object, e::Env)
    c = evaluate(a.car, e)
    if c != NIL
        evaluate(a.cdr.car, e)
    elseif a.cdr.cdr != NIL
        evaluate(a.cdr.cdr.car, e)
    else
        NIL
    end
end

include("./repl.jl")

end # module
