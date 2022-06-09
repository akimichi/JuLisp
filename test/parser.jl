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
    @testset "symbol" begin
      @test symbol("abc") == parser("abc")
      @test a == parser("a")
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
  @testset "atom" begin
    @test Num(1) == parser(num,"1")
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
  end
  @testset "quoted_symbol" begin
    @test  cons(QUOTE, symbol("a"))  == parser(quoted_symbol,"'a")
  end
  @testset "quoted_exp" begin
    # @test  cons(QUOTE, cons(symbol("a"), NIL))  == parser(quoted_exp,"'a")
    # @test cons(Num(1), cons(Num(2),NIL))  == parser(quoted_exp,"'(1 2)")
  end
  
end

@testset "evaluate" begin
  e = defaultEnv()
  @test Num(1) == evaluate(parser(num, "1"), e)
  # @test a == evaluate(parser(quoted_symbol, "'a"), e)

end
