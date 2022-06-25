@testset "section 1-1" begin
  @testset "section 1-1-1" begin
    e = defaultEnv()
    @test Num(486) == evaluate(parser("(+ 137 349)"), e)
    @test Num(666) == evaluate(parser("(- 1000 334)"), e)
    @test Num(495) == evaluate(parser("(* 5 99)"), e)
    @test Num(2.0) == evaluate(parser("(/ 10 5)"), e)
    # @test Num(2.0) == evaluate(parser("(+ 2.7 10)"), e)
  end
end


