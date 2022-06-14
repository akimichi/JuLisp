
evaluate(atom, env::Env) = atom
# evaluate(date::DateType, env::Env) = date

evaluate(variable::Sym, env::Env) = get(env, variable)

function evaluate(e::Pair, env::Env)
    closure = evaluate(e.car, env)
    closure.apply(closure, e.cdr, env)
end


function evlis(args::Object, env::Env)
    args isa Pair ? Pair(evaluate(args.car, env), evlis(args.cdr, env)) : NIL 
end

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

