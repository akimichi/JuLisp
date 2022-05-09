@testset "env" begin
  @testset "consの挙動を確認する" begin
      e = env()
      define(e, b, cons(b, c))
      define(e, a, a)
      @test a          == get(e, a)
      @test cons(b, c) == get(e, b)
      define(e, a, cons(a, b))
      @test cons(a, b) == get(e, a)


      e = env()
      define(e, b, cons(b, c))
      @test_throws ErrorException get(e, c)


      e = env()
      define(e, a, a)
      define(e, a, cons(a, b))
      @test cons(a, b) == get(e, a)
  end

  @testset "defaultEnv" begin
      e = defaultEnv()
      @test NIL == evaluate(NIL, e)
      @test T == evaluate(T, e)
      @test T == evaluate(lispRead("(atom 'a)"), e)
      @test T == evaluate(lispRead("(eq 'a 'a)"), e)
      @test NIL == evaluate(lispRead("(eq 'a 'b)"), e)
      @test T == evaluate(lispRead("(eq (cons 'a 'b) (cons 'a 'b))"), e)
      @test a == evaluate(lispRead("(car '(a . b))"), e)
      @test b == evaluate(lispRead("(cdr '(a . b))"), e)
      @test cons(a, b) == evaluate(lispRead("(cons 'a 'b)"), e)
      @test cons(a, cons(b, NIL)) == evaluate(lispRead("(list 'a 'b)"), e)
      @test cons(a, b) == evaluate(lispRead("((lambda (a b) (cons a b)) 'a 'b)"), e)
      @test a == evaluate(lispRead("(define a 'a)"), e)
      @test a == evaluate(lispRead("a"), e)
      @test a == evaluate(lispRead("(if t 'a 'b)"), e)
      @test b == evaluate(lispRead("(if nil 'a 'b)"), e)
      @test NIL == evaluate(lispRead("(if nil 'a)"), e)
  end
end

