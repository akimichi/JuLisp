using JuLisp

@testset "DateType" begin
  @testset "mkString" begin
    @test "@2022-06-18" == mkString(date("2022-06-18"))
  end
end
