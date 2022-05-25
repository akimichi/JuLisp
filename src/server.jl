#!/opt/julia/bin/julia

#=
    ソケットサーバ
    1:1 のコネクションを複数接続可
    Todo : シグナル見て停止とかタイムアウトとかサーバらしい実装が必要
=#
# ソケットを準備
using Sockets
using JuLisp

env = defaultEnv()
parse(str::String) = JuLisp.read(LispReader(str))

# @async begin
  server = listen(IPv4(0),2000)

  # 無限ループさせる
  while true
      # 接続待ち
      socket = accept(server)
      # 接続が来たら、@asyncでコルーチン生成
      # 接続をコピー
      # peer = socket
      @async while isopen(socket)
          try
            # 接続をコピー
            # peer = socket
            # リクエスト読込
            # line = readline(peer)
            # line = readline(peer, keep=true)
            line = readline(socket, keep=true)
            print(string(line))
            exp = parse(line)
            # リクエストによって処理を分ける（サンプル：(exit)が来たらサーバ終了）
            if chomp(line) == "(exit)"
              # 接続を切る
              # close(peer)
              close(socket)
              exit()
            end
            result = JuLisp.evaluate(exp, env)
            println(result)

            # レスポンスの書き出し
            # write(peer, string(result) * '\n')
            write(socket, string(result))
            # 接続を切る
            # close(peer)
        catch err
          println("エラーです")
          println(err)
          exit()
        end
      end
  end
# end
