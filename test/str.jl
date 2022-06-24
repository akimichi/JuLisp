using JuLisp

@testset "string" begin
  @test "\'abc\'" == string(str("abc"))
end


