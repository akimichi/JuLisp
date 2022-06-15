@testset "evaluate" begin
    e = defaultEnv()
    @testset "atom" begin
      @test Num(1) == evaluate(parser(num_token, "1"), e)
      @test a == evaluate(parser("'a"), e)
      @test NIL == evaluate(NIL, e)
      @test T == evaluate(T, e)
    end
    @testset "quoted" begin
      @test a == evaluate(parser(quoted_symbol, "'a"), e)
      @test cons(a,b) == evaluate(parser("'(a . b)"), e)
    end
    @testset "predicate" begin
      @test T == evaluate(parser("(atom? 'a)"), e)
      @test T == evaluate(parser("(eq 'a 'a)"), e)
      @test F == evaluate(parser("(eq 'a 'b)"), e)
      @test T == evaluate(parser("(eq (cons 'a 'b) (cons 'a 'b))"), e)
    end

    @testset "operator" begin
      @test Num(3) == evaluate(parser("(+ 1 2)"), e)
      @test Num(1024) == evaluate(parser("(^ 2 10)"),e)
      @test Num(6) == evaluate(parser("(* (+ 1 2)  (- 6 4))"),e)
      @test Num(3) == evaluate(parser("(+ 1 2)"), e)
      @test a == evaluate(parser("(car '(a . b))"), e)
      @test b == evaluate(parser("(cdr '(a . b))"), e)
      @test cons(a, b) == evaluate(parser("(cons 'a 'b)"), e)
      @test cons(a, cons(b, NIL)) == evaluate(parser("(list 'a 'b)"), e)
      @test a == evaluate(parser("(car '(a . b))"), e)
      @test b == evaluate(parser("(cdr '(a . b))"), e)
      @test cons(a, b) == evaluate(parser("(cons 'a 'b)"), e)
      @test cons(a, NIL) == evaluate(parser("(cons 'a nil)"), e)
      @test list(a, b, c) == evaluate(parser("(list 'a 'b 'c)"), e)

      @test today() == evaluate(parser("(today!)"), e)
    end 
    @testset "special" begin
      @test a == evaluate(parser("(define a 'a)"), e)
      @test cons(a, b) == evaluate(parser("((lambda (a b) (cons a b)) 'a 'b)"), e)
      @test a == evaluate(parser("(define a 'a)"), e)
      @test a == evaluate(parser("(if T 'a 'b)"), e)
      @test a == evaluate(parser("(if nil 'a 'b)"), e)
      @test a == evaluate(parser("(if nil 'a)"), e)
    end
    @testset "Closure" begin
         e = defaultEnv()
         @test a == evaluate(parser("((lambda (a) (car a)) '(a . b))"), e)
        define(e, symbol("kar"), closure(list(a), parser("((car a))"), e))
        @test a == evaluate(parser("(kar '(a . b))"), e) 
        @test b == evaluate(parser("(define a 'b)"), e)
        @test b == evaluate(a, e)
        evaluate(parser("(define kons (lambda (a b) (cons a b)))"), e)
        @test cons(a, b) == evaluate(parser("(kons 'a 'b)"), e)
    end


end

@testset "defaultEnv" begin
    e = defaultEnv()
    @test T == evaluate(parser("(eq 'a 'a)"), e)
    @test F == evaluate(parser("(eq 'a 'b)"), e)
    @test T == evaluate(parser("(eq (cons 'a 'b) (cons 'a 'b))"), e)
    @test a == evaluate(parser("(car '(a . b))"), e)
    @test b == evaluate(parser("(cdr '(a . b))"), e)
    @test cons(a, b) == evaluate(parser("(cons 'a 'b)"), e)
    @test cons(a, cons(b, NIL)) == evaluate(parser("(list 'a 'b)"), e)
    @test cons(a, b) == evaluate(parser("((lambda (a b) (cons a b)) 'a 'b)"), e)
    @test a == evaluate(parser("(define a 'a)"), e)
    @test a == evaluate(parser("a"), e)
    @test a == evaluate(parser("(if T 'a 'b)"), e)
    @test a == evaluate(parser("(if nil 'a 'b)"), e)
    @test a == evaluate(parser("(if nil 'a)"), e)
end

#@testset "Closure" begin
#    e = defaultEnv()
#    @test a == evaluate(lispRead("((lambda (a) (car a)) '(a . b))"), e)
#    define(e, symbol("kar"), closure(list(a), lispRead("((car a))"), e))
#    @test a == evaluate(lispRead("(kar '(a . b))"), e) 
#    @test b == evaluate(lispRead("(define a 'b)"), e)
#    @test b == evaluate(a, e)
#    evaluate(lispRead("(define kons (lambda (a b) (cons a b)))"), e)
#    @test cons(a, b) == evaluate(lispRead("(kons 'a 'b)"), e)
#end

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
