
function interpret(in::IO, out::IO, prompt::String)
    env = defaultEnv()
    while true
        print(out, prompt)
        flush(out)
        exp = read(in)
        # println(out, "x=$x")
        if exp == END_OF_EXPRESSION || exp == symbol("quit")
            break
        end
        show(out, evaluate(exp, env))
        println(out)
    end
    return out
end
