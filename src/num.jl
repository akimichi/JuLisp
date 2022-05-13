struct Num <: Object
    value::Number
end
function number(value::String)
  num = parse(Float64, value)
  isinteger(num) ? Int(num) : num
  Num(num)
end
show(io::IO, n::Num) = print(io, n.value)

evaluate(number::Num, env::Env) = number

