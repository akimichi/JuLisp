struct Num <: Object
    value::Number
end

function number(value::String)::Num
  num = parse(Float64, value)
  isinteger(num) ? Num(Int(num)) : Num(num)
end
mkString(n::Num) = string(n.value)
show(io::IO, n::Num) = print(io, n.value)
value(n::Num) = n.value


