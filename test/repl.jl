
@testset "repl" begin
    proc(str::String) = repl(LispReader(str), IOBuffer(), "")
    @test "t\n" == String(take!(proc("(atom 'a)")))
end
