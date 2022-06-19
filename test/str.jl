using JuLisp

@testset "mkString" begin
  @test "\'abc\'" == mkString(str("abc"))
end


