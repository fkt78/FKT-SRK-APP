#!/bin/bash
# 出張アプリ保存ファイル名変更.html をポート9000で表示するスクリプト
cd "$(dirname "$0")"
echo "ポート 9000 でHTTPサーバーを起動しています..."
echo "ブラウザで以下を開いてください:"
echo "  http://localhost:9000/出張アプリ保存ファイル名変更.html"
echo ""
echo "終了するには Ctrl+C を押してください。"
python3 -m http.server 9000
