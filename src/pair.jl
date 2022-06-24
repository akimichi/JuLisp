using JuLisp

struct Pair <: Object
    car::Object
    cdr::Object
end

cons(a::Object, b::Object) = Pair(a, b)
car(e::Pair) = e.car
cdr(e::Pair) = e.cdr


function show(io::IO, instance::Pair)
  print(io, string("($(instance.car) . $(instance.cdr))"))
end
