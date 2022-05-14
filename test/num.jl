@testset "Number" begin
    @test 10 == number("10").value
    @test Num(0) == evaluate(Num(0), emptyEnv())
end


