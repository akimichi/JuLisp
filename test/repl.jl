
@testset "repl" begin
    proc(str::String) = repl(LispReader(str), IOBuffer(), "")
    @test "#t\n" == String(take!(proc("(atom 'a)")))
    @test "#t\n" == String(take!(proc("(null nil)")))
    @test "#f\n" == String(take!(proc("(null 'a)")))
    @test "#f\n" == String(take!(proc("(null #t)")))
end
