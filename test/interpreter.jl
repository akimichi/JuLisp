
@testset "interpret" begin
#     proc(str::String) = repl(parser(str), IOBuffer(), "")
#     @test "T\n" == String(take!(proc("(atom? 'a)")))
#     @test "T\n" == String(take!(proc("(null? nil)")))
#     @test "F\n" == String(take!(proc("(null? 'a)")))
#     @test "F\n" == String(take!(proc("(null? T)")))
#     @test "1\n" == String(take!(proc("1")))
#     @test "3\n" == String(take!(proc("(+ 1 2)")))
#     @test "-1\n" == String(take!(proc("(- 3 4)")))
#     @test "1024\n" == String(take!(proc("(^ 2 10)")))
#     @test "6\n" == String(take!(proc("(* (+ 1 2)  (- 6 4))")))
end
