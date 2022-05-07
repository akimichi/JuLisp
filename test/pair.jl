@testset "Pair" begin
    @test a == car(cons(a, b))
    @test b == cdr(cons(a, b))
    @test !null(cons(a, b))
    @test !atom(cons(a, b))
    @test NIL == list()
    la = list(a)
    @test a == car(la)
    @test NIL == cdr(la)
    @test cons(a, NIL) == list(a)
    @test cons(a, cons(b, NIL)) == list(a, b)
    @test "(a . b)" == string(cons(a, b))
    @test "(a b)" == string(cons(a, cons(b, NIL)))
    @test "'a" == string(cons(QUOTE, cons(a, NIL)))
    @test "(quote . a)" == string(cons(QUOTE, a))
    @test "'(a b)" == string(cons(QUOTE, cons(cons(a, cons(b, NIL)), NIL)))
end

