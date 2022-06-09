export interpret

function interpret(in::IO, out::IO, prompt::String)
    env = defaultEnv()
    while true
        print(out, prompt)
        flush(out)
        input::String = readline(in)
        # println(out, "x=$x")
        if symbol(input) == END_OF_EXPRESSION || symbol(input) == symbol("quit")
            break
        end
        exp = parser(input)
        show(out, evaluate(exp, env))
        println(out)
    end
    return out
end

interpret() = interpret(Base.stdin, Base.stdout, "JuLisp> ")
