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
    env = emptyEnv()
    define(env, NIL, NIL)
    define(env, T, T)
    define(env, symbol("atom"), procedure(args -> predicate(atom(args.car))))
    define(env, symbol("null"), procedure(args -> predicate(null(args.car))))
    define(env, symbol("eq"), procedure(args -> predicate(args.car == args.cdr.car)))
    define(env, symbol("car"), procedure(args -> args.car.car))
    define(env, symbol("cdr"), procedure(args -> args.car.cdr))
    define(env, symbol("cons"), procedure(args -> Pair(args.car, args.cdr.car)))
    define(env, symbol("plus"), procedure(args -> args.car.value + args.cdr.value))
    define(env, symbol("list"), procedure(args -> args))
    define(env, QUOTE, special((s, args, env) -> args.car))
    define(env, symbol("lambda"), special((s, args, env) -> closure(args.car, args.cdr, env)))
    define(env, symbol("define"), special((s, args, env) -> define(env, args.car, evaluate(args.cdr.car, env))))
    define(env, symbol("if"), special(lispIf))
    return env
end

