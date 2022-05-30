@testset "section 1-1" begin
  @testset "section 1-1-1" begin
    e = defaultEnv()
    @test Num(486) == evaluate(lispRead("(+ 137 349)"), e)
    @test Num(666) == evaluate(lispRead("(- 1000 334)"), e)
    @test Num(495) == evaluate(lispRead("(* 5 99)"), e)
    @test Num(2.0) == evaluate(lispRead("(/ 10 5)"), e)
    # @test Num(2.0) == evaluate(lispRead("(+ 2.7 10)"), e)
  end
end


