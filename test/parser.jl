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
    @testset "date_token" begin
      @test date("2022-06-14") == parser(date_token, "@2022-06-14")
    end
  end
end

@testset "parser rule" begin
  @testset "prefix" begin
    @test "+" == parser(prefix,"+")
    @test "*" == parser(prefix,"*")
    @test "|" == parser(prefix,"|")
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
    @test cons(Num(1), cons(Num(2),NIL))  == parser(sequence,"(1 2)")
    @test cons(Num(1), NIL)  == parser(sequence,"(1)")
    @test cons(symbol("car"), cons(Num(1), NIL))  == parser(sequence,"(car 1)")
  end
  @testset "dotted_pair" begin
    @test cons(Num(1), Num(2))  == parser(dotted_pair, "(1 . 2)")
    @test cons(a, b)  == parser(dotted_pair, "(a . b)")
    @test cons(a, cons(b, c))  == parser(dotted_pair, "(a b . c)")
  end
  @testset "quoted_symbol" begin
    @test  cons(QUOTE, symbol("a"))  == parser(quoted_symbol,"'a")
    # @test  cons(QUOTE, cons(symbol("a"),NIL))  == parser(quoted_symbol,"'a")
  end
  @testset "quoted_sequence" begin
    @test cons(QUOTE, cons(Num(1), cons(Num(2),NIL)))  == parser(quoted_sequence,"'(1 2)")
    @test "(quote . (1 . (2 . nil)))" == string(parser(quoted_sequence,"'(1 2)"))
    # @test "(quote . (1 . (2 . nil)))" == string(parser(quoted_sequence,"'(1 2)"))
    # (QUOTE (a . b))
    @test "(quote . (a . (b . nil)))" == string(parser(quoted_sequence,"'(a b)"))
    @test "(a . (b . nil))"  == string(parser(sequence,"(a b)"))
    @test "(a . b)"  == string(parser(dotted_pair,"(a . b)"))
    @test "(a . b)"  == string(parser(sequence,"(a . b)"))
    @test "(quote . (a . b))"  == string(parser(quoted_sequence,"'(a . b)"))
  end
  @testset "define" begin
    @test list(symbol("define"), symbol("kons"), list(symbol("lambda"), list(a, b), list(symbol("cons"), a, b))) == parser("(define kons (lambda (a b) (cons a b)))")
  end
end

