@testset "parser" begin
  @testset "number" begin
    @test Num(1) == parser("1")
    @test Num(0.01) == parser("0.01")
    @test Num(-30) == parser("-30")
  end
  @testset "string" begin
    @test Str("abc") == parser("\"abc\"")
  end
end
