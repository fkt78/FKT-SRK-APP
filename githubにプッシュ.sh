#!/bin/bash
# 出張日当管理アプリを https://github.com/fkt78/FKT-SRK-APP にプッシュするスクリプト
# ターミナル.app などで実行してください（Cursor内のターミナルでは権限エラーになる場合があります）

set -e
APP_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$APP_DIR"

echo "=== 出張日当管理アプリ → GitHub (fkt78/FKT-SRK-APP) ==="
echo "フォルダ: $APP_DIR"
echo ""

# 有効な git リポジトリでない場合は初期化（不完全な .git があれば削除してから init）
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  [ -d .git ] && echo "不完全な .git を削除して、やり直します..." && rm -rf .git
  echo "git リポジトリを初期化しています..."
  git init
  git branch -M main
fi

echo "ファイルを追加しています..."
git add .
echo ""

if git diff --cached --quiet 2>/dev/null && git diff --quiet 2>/dev/null; then
  echo "変更がありません。既に最新の状態です。"
  if ! git remote get-url origin &>/dev/null; then
    echo "リモートが未設定です。以下で追加してください:"
    echo "  git remote add origin https://github.com/fkt78/FKT-SRK-APP.git"
    echo "  git push -u origin main"
  else
    echo "プッシュするには: git push origin main"
  fi
  exit 0
fi

git status
echo ""
read -p "この内容でコミットしてプッシュしますか? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "キャンセルしました。"
  exit 0
fi

git commit -m "出張日当管理アプリ（出張旅費精算）を追加・更新"

if ! git remote get-url origin &>/dev/null; then
  echo "リモートを追加しています..."
  git remote add origin https://github.com/fkt78/FKT-SRK-APP.git
fi

echo "GitHub にプッシュしています..."
git push -u origin main

echo ""
echo "完了しました: https://github.com/fkt78/FKT-SRK-APP"
