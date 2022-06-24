@testset "Num" begin
    @test 10 == number("10").value
    @test "10" == string(number("10"))

    @test Num(0) == evaluate(Num(0), emptyEnv())

end


