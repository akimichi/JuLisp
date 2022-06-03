@testset "parser" begin
  @testset "atom" begin
    @testset "number" begin
      @test Num(1) == parser("1")
      @test Num(0.01) == parser("0.01")
      @test Num(-30) == parser("-30")
    end
    @testset "string" begin
      @test Str("abc") == parser("\"abc\"")
    end
    @testset "symbol" begin
      @test symbol("abc") == parser("abc")
    end
    @testset "compound" begin
      # @test a == parser("'a")
      # @test Pair(Num(1), NIL) == parser("(1)")
      @test cons(Num(1), NIL) == parser("(1)")
    end
  end
end
@testset "evaluate" begin
  e = defaultEnv()
  @test a == evaluate(parser("'a"), e)

end
