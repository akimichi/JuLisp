struct Num <: Object
    value::Number
end

function number(value::String)::Num
  num = parse(Float64, value)
  isinteger(num) ? Num(Int(num)) : Num(num)
end

function show(io::IO, n::Num)
  print(io, n.value)
end

value(n::Num) = n.value


