using JuLisp
using Test

a = symbol("a")
b = symbol("b")
c = symbol("c")
d = symbol("d")

@testset "value" begin
  include("./symbol.jl")
  include("./num.jl")
  include("./str.jl")
  include("./date.jl")
end
@testset "datatype" begin
  include("./pair.jl")
end

@time @testset "parser" begin
  include("./parser.jl")
end


@testset "environment" begin
  include("./env.jl")
end


@time  @testset "evaluate" begin
  include("./evaluate.jl")
end
@time @testset "closure" begin
  # include("./closure.jl")
    e = defaultEnv()
    @testset "kons" begin
      # evaluate(parser("(define kons (lambda (a b) (cons a b)))"), e)
      # @test cons(a, b) == evaluate(parser("(kons 'a 'b)"), e)
      @test cons(a, b) == evaluate(parser("(cons 'a 'b)"), e)
    end
end
@time @testset "define" begin
    e = defaultEnv()
    @test b == evaluate(parser("(define a 'b)"), e)
    @test b == evaluate(a, e)
    evaluate(parser("(define kons (lambda (a b) (cons a b)))"), e)
    @test cons(a, b) == evaluate(parser("(kons 'a 'b)"), e)
end
@time @testset "kar" begin
  e = defaultEnv()
  define(e, symbol("kar"), closure(list(a), parser("((car a))"), e))
  @test a == evaluate(parser("(kar '(a . b))"), e) 
end

@time @testset "car" begin
  e = defaultEnv()
  @test a == evaluate(parser("((lambda (a) (car a)) '(a . b))"), e)
end


@time @testset "repl" begin
  include("./repl.jl")
end
@time @testset "SICP" begin
  include("./SICP/section-1-1.jl")
end





