module JuLisp

import Base.==, Base.show, Base.get, Base.Iterators

export null, atom
export NIL, T, QUOTE
export symbol
export cons, car, cdr, list
export env, get, define, set
export special, procedure, evaluate
export closure
export LispReader, lispRead

"""
Lispオブジェクトの抽象型です。
すべてのLispオブジェクトはこの型を継承する必要があります。
"""
abstract type Object end

"""
Lispにおけるシンボルの型です。
"""
struct Sym <: Object
    symbol::Symbol
end
symbol(name::String) = Sym(Symbol(name))
const NIL = symbol("nil")
const T = symbol("t")
const QUOTE = symbol("quote")
const END_OF_EXPRESSION = symbol("*end-of-expression*")
null(e::Object) = e == NIL
atom(e::Sym) = true
show(io::IO, e::Sym) = print(io, e.symbol)

"""
コンスセルの型です。
"""
struct Cons <: Object
    car::Object
    cdr::Object
end
atom(e::Cons) = false
cons(a::Object, b::Object) = Cons(a, b)
car(e::Cons) = e.car
cdr(e::Cons) = e.cdr
function list(args::Object...)
    r = NIL
    for e in reverse(args)
        r = cons(e, r)
    end
    return r
end
function show(io::IO, e::Cons)
    x::Object = e
    print(io, "(")
    sep = ""
    while x isa Cons
        print(io, sep, x.car)
        sep = " "
        x = x.cdr
    end
    if x != NIL
        print(io, " . ", x)
    end
    print(io, ")")
end

"""
変数の束縛を保持する型です。
"""
mutable struct Env
    bind::Object
end
env() = Env(NIL)

function find(env::Env, variable::Sym)
    bind = env.bind
    while bind != NIL
        if variable == bind.car.car
            return bind.car
        end
        bind = bind.cdr
    end
    error("Variable $variable not found")
end

get(env::Env, var) = find(env, var).cdr

function define(env::Env, var::Sym, val::Object)
    env.bind = Cons(Cons(var, val), env.bind) 
    return val
end

"""
Apply可能なLispオブジェクトの型です。
"""
struct Applicable <: Object
    apply::Function
end

special(f::Function) = Applicable(f)

function evlis(args::Object, env::Env)
    args isa Cons ? Cons(evaluate(args.car, env), evlis(args.cdr, env)) : NIL 
end

function procedure(f::Function)
    Applicable((this, args, env) -> f(evlis(args, env)))
end

evaluate(variable::Sym, env::Env) = get(env, variable)

function evaluate(e::Cons, env::Env)
    a = evaluate(e.car, env)
    a.apply(a, e.cdr, env)
end

struct Closure <: Object
    parms::Object
    body::Object
    env::Env
    apply::Function
end

function closureApply(closure::Closure, args::Object, env::Env)
    function pairlis(parms::Object, args::Object, env::Env)
        while (parms isa Cons)
            define(env, parms.car, args.car)
            parms = parms.cdr
            args = args.cdr
        end
        if parms != NIL
            define(env, parms, args)
        end
    end
    nenv = Env(closure.env.bind)
    pairlis(closure.parms, evlis(args, env), nenv)
    return evaluate(closure.body.car, nenv)
end

closure(parms::Object, body::Object, env::Env) = Closure(parms, body, env, closureApply)

const EOF = '\uFFFF'

mutable struct LispReader
    in::IO
    ch::Char
end

getch(r::LispReader) = eof(r.in) ? r.ch = EOF : r.ch = read(r.in, Char)

function LispReader(in::IO)
    r = LispReader(in, EOF)
    getch(r)
    r
end

LispReader(s::String) = LispReader(IOBuffer(s))

function Base.read(r::LispReader)

    DOT = symbol(".")

    function skipSpaces()
        while isspace(r.ch)
            getch(r)
        end
    end

    function makeList(elements::Array{Object, 1}, last::Object)
        if last == NIL
            list(elements...)
        else
            for e in reverse(elements)
                last = cons(e, last)
            end
            return last
        end
    end

    function readList()
        elements = Array{Object, 1}()
        last = NIL
        while true
            skipSpaces()
            if r.ch == ')'
                getch(r)
                return makeList(elements, last)
            elseif r.ch == EOF
                error(") expected")
            else
                e = readObject()
                if e == DOT
                    last = read(r)
                    skipSpaces()
                    if r.ch != ')'
                        error(") expected")
                    end
                    getch(r) # skip ')'
                    return makeList(elements, last)
                end
                push!(elements, e)
            end
        end
    end

    isdelim(c::Char) = occursin(c,  "'(),\"")
    issymbol(c::Char) = c != EOF && !isspace(c) && !isdelim(c)

    function readSymbol(s::String)
        while issymbol(r.ch)
            s *= r.ch
            getch(r)
        end
        return symbol(s)
    end

    function readAtom()
        first = r.ch
        s = "" * first
        getch(r)
        if first == '.'
            return issymbol(r.ch) ? readSymbol(s) : DOT
        else
            return readSymbol(s)
        end
    end

    function readObject()
        skipSpaces()
        if r.ch == EOF
            return END_OF_EXPRESSION
        elseif r.ch == '('
            getch(r)
            return readList()
        else
            return readAtom()
        end
    end

    obj = readObject()
    if obj == DOT
        error("unexpected '.'")
    end
    return obj
end

lispRead(s::String) = read(LispReader(s))

end # module
