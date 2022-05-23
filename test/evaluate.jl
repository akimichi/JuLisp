@testset "evaluate" begin
    e = defaultEnv()
    @test a == evaluate(lispRead("'a"), e)
    @test a == evaluate(lispRead("(car '(a . b))"), e)
    @test b == evaluate(lispRead("(cdr '(a . b))"), e)
    @test cons(a, b) == evaluate(lispRead("(cons 'a ' b)"), e)
    @test cons(a, NIL) == evaluate(lispRead("(cons 'a nil)"), e)
    @test list(a, b, c) == evaluate(lispRead("(list 'a 'b 'c)"), e)
end

@testset "defaultEnv" begin
    e = defaultEnv()
    @test NIL == evaluate(NIL, e)
    @test T == evaluate(T, e)
    @test T == evaluate(lispRead("(atom? 'a)"), e)
    @test T == evaluate(lispRead("(eq 'a 'a)"), e)
    @test F == evaluate(lispRead("(eq 'a 'b)"), e)
    @test T == evaluate(lispRead("(eq (cons 'a 'b) (cons 'a 'b))"), e)
    @test a == evaluate(lispRead("(car '(a . b))"), e)
    @test b == evaluate(lispRead("(cdr '(a . b))"), e)
    @test cons(a, b) == evaluate(lispRead("(cons 'a 'b)"), e)
    @test cons(a, cons(b, NIL)) == evaluate(lispRead("(list 'a 'b)"), e)
    @test cons(a, b) == evaluate(lispRead("((lambda (a b) (cons a b)) 'a 'b)"), e)
    @test a == evaluate(lispRead("(define a 'a)"), e)
    @test a == evaluate(lispRead("a"), e)
    @test a == evaluate(lispRead("(if T 'a 'b)"), e)
    @test a == evaluate(lispRead("(if nil 'a 'b)"), e)
    @test a == evaluate(lispRead("(if nil 'a)"), e)
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
             (if (null? a)
                 b
                 (cons (car a) (append (cdr a) b))  )))
          """), e)
    @test list(a, b, c, d) == evaluate(lispRead("(append '(a b) '(c d))"), e)
end
