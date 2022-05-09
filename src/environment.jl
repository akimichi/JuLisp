"変数の束縛を保持する型です"
mutable struct Env
    bindings::Object
end

emptyEnv() = Env(NIL)

get(env::Env, var) = find(env, var).cdr
show(io::IO, environment::Env) = print(io, "{$(environment.bindings)}")


function find(env::Env, variable::Sym)
    bindings = env.bindings
    while bindings != NIL
        if variable == bindings.car.car
            return bindings.car
        end
        bindings = bindings.cdr
    end
    error("Variable $variable not found")
end


function defaultEnv()
    e = emptyEnv()
    define(e, NIL, NIL)
    define(e, T, T)
    define(e, symbol("atom"), procedure(a -> predicate(atom(a.car))))
    define(e, symbol("null"), procedure(a -> predicate(null(a.car))))
    define(e, symbol("eq"), procedure(a -> predicate(a.car == a.cdr.car)))
    define(e, symbol("car"), procedure(a -> a.car.car))
    define(e, symbol("cdr"), procedure(a -> a.car.cdr))
    define(e, symbol("cons"), procedure(a -> Pair(a.car, a.cdr.car)))
    define(e, symbol("list"), procedure(a -> a))
    define(e, QUOTE, special((s, a, e) -> a.car))
    define(e, symbol("lambda"), special((s, a, e) -> closure(a.car, a.cdr, e)))
    define(e, symbol("define"), special((s, a, e) -> define(e, a.car, evaluate(a.cdr.car, e))))
    define(e, symbol("if"), special(lispIf))
    return e
end

