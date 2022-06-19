using JuLisp

@testset "mkString" begin
  @test "abc" == mkString(symbol("abc"))
end

@testset "LispSymbol" begin
    @test T == symbol("T")
    @test QUOTE == symbol("quote")
    @test symbol("a") == symbol("a")
end

@testset "NIL" begin
    @test NIL == symbol("nil")
    @test "nil" == string(NIL)
    @test null(NIL)
    @test atom(NIL)
end

@testset "T" begin
    @test T == symbol("T")
    @test "T" == string(T)
    @test !null(T)
    @test atom(T)
end

@testset "atom" begin
    @test symbol("a") == a
    @test "a" == string(a)
    @test !null(a)
    @test atom(a)
end


