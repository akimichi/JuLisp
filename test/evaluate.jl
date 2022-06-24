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
      @test cons(a, b) == evaluate(parser("((lambda (a b) (cons a b)) 'a 'b)"), e)
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

end



# @testset "append" begin
#     e = defaultEnv()
#     evaluate(parser("""
#         (define append
#             (lambda (a b)
#              (if (null? a)
#                  b
#                  (cons (car a) (append (cdr a) b))  )))
#           """), e)
#     @test list(a, b, c, d) == evaluate(parser("(append '(a b) '(c d))"), e)
# end
