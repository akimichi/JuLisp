using JuLisp

@testset "DateType" begin
  @testset "string" begin
    @test "@2022-06-18" == string(date("2022-06-18"))
  end
end
