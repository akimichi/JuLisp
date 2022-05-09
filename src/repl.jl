
function repl(in::LispReader, out::IO, prompt::String)
    e = defaultEnv()
    while true
        print(out, prompt)
        flush(out)
        x = read(in)
#        println(out, "x=$x")
        if x == END_OF_EXPRESSION || x == symbol("quit")
            break
        end
        show(out, evaluate(x, e))
        println(out)
    end
    return out
end

repl(in::IO, out::IO, prompt::String) = repl(LispReader(in), out, prompt)
repl() = repl(Base.stdin, Base.stdout, "JuLisp> ")
