"クロージャです"
struct Closure <: Object
    parms::Object
    body::Object
    env::Env    # クロージャが定義された時の変数束縛
    apply::Function # クロージャの関数本体
end

"クロージャを作成します"
closure(parms::Object, body::Object, env::Env) = Closure(parms, body, env, closureApply)

"クロージャの表示関数"
show(io::IO, c::Closure) = print("Closure{$(c.parms), $(c.body)}")

function closureApply(closure::Closure, args::Object, env::Env)
    function pairlis(parms::Object, args::Object, env::Env)
        while (parms isa Pair)
            define(env, parms.car, args.car)
            parms = parms.cdr
            args = args.cdr
        end
        if parms != NIL
            define(env, parms, args)
        end
    end
    newEnv = Env(closure.env.bindings)
    pairlis(closure.parms, evlis(args, env), newEnv)
    return evaluate(closure.body.car, newEnv)
end

