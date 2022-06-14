@testset "parser" begin
  @testset "atom" begin
    @testset "number" begin
      @test Num(1) == parser("1")
      @test Num(0.01) == parser("0.01")
      @test Num(-30) == parser("-30")
    end
    @testset "string" begin
      @test Str("abc") == parser("\"abc\"")
    end
    @testset "compound" begin
      #@test Pair(Num(1), NIL) == parser("'(1)")
      # @test cons(Num(1), NIL) == parser("( 1 2 )")
      # @test cons(Num(1), NIL) == parser("(1)")
      # @test cons(Num(1), NIL) == parser("( 1 )")
      # @test cons(Num(1), NIL) == parser(" ( 1 )")
      # @test cons(Num(1), NIL) == parser(" ( 1)")
    end
  end
end

@testset "parser rule" begin
  @testset "head_sign" begin
    @test "+" == parser(head_sign,"+")
    @test "*" == parser(head_sign,"*")
    @test "|" == parser(head_sign,"|")
  end
  @testset "initial" begin
    @test "a" == parser(initial,"a")
    @test "+" == parser(initial,"+")
  end
  @testset "subsequent" begin
    @test "a" == parser(subsequent,"a")
    @test "3" == parser(subsequent,"3")
  end
  @testset "identifier" begin
    @test a == parser(identifier,"a")
    @test a == parser(identifier,"a b")
    @test Sym(Symbol("abc")) == parser(identifier,"abc")
    @test Sym(Symbol("+")) == parser(identifier,"+")
    @test Sym(Symbol("push!")) == parser(identifier,"push!")
  end
  @testset "letter" begin
    @test "a" == parser(letter,"a")
    @test "a" == parser(letter,"a b")
  end
  @testset "digit" begin
    @test "3" == parser(digit,"3")
  end
  @testset "symbol_token" begin
    @test a == parser("a")
    # @test a == parser("a b")
    @test symbol("abc") == parser(symbol_token, "abc")
  end
  @testset "atom" begin
    @test Num(1) == parser(num_token,"1")
    @test Str("abx") == parser(string_token,"\"abx\"")
    @test symbol("abc") == parser(symbol_token, "abc")
  end
  @testset "items" begin
    # Any[1,2]
    @test [Num(1), Num(2)]  == parser(items,"1 2")
  end
  @testset "list_token" begin
    @test cons(Num(1), cons(Num(2),NIL))  == parser(list_token,"(1 2)")
    @test cons(Num(1), NIL)  == parser(list_token,"(1)")
    @test cons(symbol("car"), cons(Num(1), NIL))  == parser(list_token,"(car 1)")
    # @test cons(symbol("car"), cons(Num(1), NIL))  == parser(list_token,"(+ 1 2)")
  end
  @testset "dotted_pair" begin
    @test cons(Num(1), Num(2))  == parser(dotted_pair, "(1 . 2)")
    @test cons(a, b)  == parser(dotted_pair, "(a . b)")
    @test cons(a, cons(b, c))  == parser(dotted_pair, "(a b . c)")
  end
  @testset "quote" begin
    @testset "quoted_symbol" begin
      @test  cons(QUOTE, cons(symbol("a"),NIL))  == parser(quoted_symbol,"'a")
      # @test  cons(QUOTE, symbol("a"))  == parser(quoted_symbol,"'a")
    end
    @testset "quoted_sequence" begin
      @test cons(QUOTE, cons(cons(Num(1), cons(Num(2),NIL)),NIL))  == parser(quoted_sequence,"'(1 2)")
      @test cons(QUOTE, cons(cons(a, b),NIL))  == parser(quoted_sequence,"'(a . b)")
    end
  end
  
end

@testset "evaluate" begin
  e = defaultEnv()
  @testset "atom" begin
    @test Num(1) == evaluate(parser(num_token, "1"), e)
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
