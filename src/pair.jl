struct Pair <: Object
    car::Object
    cdr::Object
end

cons(a::Object, b::Object) = Pair(a, b)
car(e::Pair) = e.car
cdr(e::Pair) = e.cdr

function show(io::IO, e::Pair)
    if e.cdr isa Pair && e.cdr.cdr == NIL
        if e.car == QUOTE
            print(io, "'", e.cdr.car)
            return
        end
    end
    x::Object = e
    print(io, "(")
    sep = ""
    while x isa Pair
        print(io, sep, x.car)
        sep = " "
        x = x.cdr
    end
    if x != NIL
        print(io, " . ", x)
    end
    print(io, ")")
end
