
@testset "repl" begin
    proc(str::String) = repl(LispReader(str), IOBuffer(), "")
    @test "T\n" == String(take!(proc("(atom? 'a)")))
    @test "T\n" == String(take!(proc("(null? nil)")))
    @test "F\n" == String(take!(proc("(null? 'a)")))
    @test "F\n" == String(take!(proc("(null? T)")))
    @test "1\n" == String(take!(proc("1")))
    @test "3\n" == String(take!(proc("(plus 1 2)")))
end
