#!/bin/bash
# 手元で動作を確認するためのローカルサーバー
# 公開せずに index.html の変更を試したいときに使います。
#
# 使い方: このファイルをダブルクリック、または
#   ./サーバー起動.sh          ポート9000で起動
#   ./サーバー起動.sh 9001     ポートを指定して起動

cd "$(dirname "$0")"
PORT="${1:-9000}"
URL="http://localhost:$PORT/"

echo "=== ローカルサーバー ==="
echo "  フォルダ: $(pwd)"
echo "  URL     : $URL"
echo ""
echo "ブラウザで上のURLを開いてください。"
echo "終了するには Ctrl+C を押します。"
echo ""
echo "※ ここで見えるのは手元のファイルです。公開サイトは"
echo "   https://shucchou-ryohi-seisan.web.app/ です。"
echo ""

# 起動を待ってからブラウザを開く
( sleep 1; command -v open >/dev/null && open "$URL" ) &

python3 -m http.server "$PORT"
