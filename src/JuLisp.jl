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
export parser

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




predicate(e::Bool) = e ? T : F

is_true(exp) = !(exp == F)
is_false(exp) = (exp == F)

function lispIf(s::Applicable, a::Object, e::Env)
    c = evaluate(a.car, e)
    if is_true(c)
    # if c != F
        evaluate(a.cdr.car, e)
    elseif a.cdr.cdr != F
        evaluate(a.cdr.cdr.car, e)
    else
        F
    end
end

include("./repl.jl")

end # module
