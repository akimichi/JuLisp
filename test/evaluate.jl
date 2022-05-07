@testset "evaluate" begin
    e = defaultEnv()
    @test a == evaluate(lispRead("'a"), e)
    @test a == evaluate(lispRead("(car '(a . b))"), e)
    @test b == evaluate(lispRead("(cdr '(a . b))"), e)
    @test cons(a, b) == evaluate(lispRead("(cons 'a ' b)"), e)
    @test cons(a, NIL) == evaluate(lispRead("(cons 'a nil)"), e)
    @test list(a, b, c) == evaluate(lispRead("(list 'a 'b 'c)"), e)
end

@testset "Closure" begin
    e = defaultEnv()
    @test a == evaluate(lispRead("((lambda (a) (car a)) '(a . b))"), e)
    define(e, symbol("kar"), closure(list(a), lispRead("((car a))"), e))
    @test a == evaluate(lispRead("(kar '(a . b))"), e) 
    @test b == evaluate(lispRead("(define a 'b)"), e)
    @test b == evaluate(a, e)
    evaluate(lispRead("(define kons (lambda (a b) (cons a b)))"), e)
    @test cons(a, b) == evaluate(lispRead("(kons 'a 'b)"), e)
end

@testset "append" begin
    e = defaultEnv()
    evaluate(lispRead("""
        (define append
            (lambda (a b)
             (if (null a)
                 b
                 (cons (car a) (append (cdr a) b))  )))
          """), e)
    @test list(a, b, c, d) == evaluate(lispRead("(append '(a b) '(c d))"), e)
end
