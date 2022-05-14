using JuLisp
using Test

a = symbol("a")
b = symbol("b")
c = symbol("c")
d = symbol("d")

@testset "value" begin
  include("./symbol.jl")
  include("./num.jl")
end
@testset "datatype" begin
  include("./pair.jl")
end

@testset "interpreter" begin
  include("./env.jl")
  include("./evaluate.jl")
  include("./repl.jl")
end





