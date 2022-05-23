@testset "env" begin
  @testset "consの挙動を確認する" begin
      e = emptyEnv()
      define(e, b, cons(b, c))
      define(e, a, a)
      @test a          == get(e, a)
      @test cons(b, c) == get(e, b)
      define(e, a, cons(a, b))
      @test cons(a, b) == get(e, a)


      e = emptyEnv()
      define(e, b, cons(b, c))
      @test_throws ErrorException get(e, c)


      e = emptyEnv()
      define(e, a, a)
      define(e, a, cons(a, b))
      @test cons(a, b) == get(e, a)
  end

end

