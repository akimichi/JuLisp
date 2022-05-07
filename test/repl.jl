
@testset "repl" begin
    proc(e::String) = repl(LispReader(e), IOBuffer(), "")
    @test "t\n" == String(take!(proc("(atom 'a)")))
end
