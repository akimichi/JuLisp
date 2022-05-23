#!/opt/julia/bin/julia

#=
    ソケットサーバ
    1:1 のコネクションを複数接続可
    Todo : シグナル見て停止とかタイムアウトとかサーバらしい実装が必要
=#
# ソケットを準備
using Sockets
using JuLisp

server = listen(2000)
env = defaultEnv()

parse(str::String) = JuLisp.read(LispReader(str))
# 無限ループさせる
while true
    # 接続待ち
    conn = accept(server)
    # 接続が来たら、@asyncでコルーチン生成
    @async begin
        try
          # 接続をコピー
          peer = conn
          # リクエスト読込
          line = readline(peer)
          println(string(line))
          exp = parse(line)
          # リクエストによって処理を分ける（サンプル：「close」が来たらサーバ終了）
          if chomp(line) == "(exit)"
              exit()
          end
          println("to evaluate")
          result = JuLisp.evaluate(exp, env)
          println(result)

          # レスポンスの書き出し
          write(peer, value(result))
          # 接続を切る
          close(peer)
      catch err
        println("エラーです")
        println(err)
      end
    end
end
