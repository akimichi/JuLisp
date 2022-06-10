mutable struct LispReader
    in::IO
    ch::Char
end
const EOF = '\uFFFF'


getch(r::LispReader) = eof(r.in) ? r.ch = EOF : r.ch = read(r.in, Char)

function LispReader(in::IO)
    r = LispReader(in, EOF)
    getch(r)
    r
end

LispReader(s::String) = LispReader(IOBuffer(s))

lispRead(s::String)::Object = read(LispReader(s))


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
                last = Pair(e, last)
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
    # isdelim(c::Char) = occursin(c,  "'(),")
    issymbol(c::Char) = c != EOF && !isspace(c) && !isdelim(c)
    isinteger(c::Char) = c != EOF && !isspace(c) && isdigit(c) 
    isdoublequote(c::Char) = c != EOF && !isspace(c) && c == '\"' 

    function readString()
        s = ""
        while isletter(r.ch)
            s *= r.ch
            getch(r)
        end
        # println("s=$s")
        # println("r.ch=$r.ch")
        if isdoublequote(r.ch)
          getch(r)
          return str(s)
        else 
          error("\" expected")
        end
    end
    function readNumber(s::String)
        while isinteger(r.ch)
            s *= r.ch
            getch(r)
        end
        return number(s)
    end
    function readSymbol(s::String)
        while issymbol(r.ch)
        # while isletter(r.ch)
            s *= r.ch
            getch(r)
        end
        return symbol(s)
    end

    function readAtom()
        first = r.ch
        s = "" * first
        # println("first=$first")
        getch(r)
        if isdoublequote(first)
            return readString()
        elseif first == '.'
            return issymbol(r.ch) ? readSymbol(s) : DOT
        elseif isdigit(first)
            return readNumber(s)
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
        elseif r.ch == '\''
            getch(r)
            return list(QUOTE, readObject())
        else
            return readAtom()
        end
    end

    obj = readObject()
    if obj == DOT
        error("unexpected '.'")
    end
    # println(out, "obj=$obj")
    return obj
end




function repl(in::LispReader, out::IO, prompt::String)
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

repl(in::IO, out::IO, prompt::String) = repl(LispReader(in), out, prompt)
repl() = repl(Base.stdin, Base.stdout, "JuLisp> ")
