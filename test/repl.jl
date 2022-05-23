
@testset "repl" begin
    proc(str::String) = repl(LispReader(str), IOBuffer(), "")
    @test "T\n" == String(take!(proc("(atom 'a)")))
    @test "T\n" == String(take!(proc("(null nil)")))
    @test "F\n" == String(take!(proc("(null 'a)")))
    @test "F\n" == String(take!(proc("(null T)")))
end
