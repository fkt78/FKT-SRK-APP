#!/bin/bash
# FKT-SRK-APP を GitHub にプッシュし、Firebase にデプロイするスクリプト

cd "$(dirname "$0")"

echo "=== 1. GitHub にプッシュ ==="
git push
if [ $? -ne 0 ]; then
  echo "エラー: git push に失敗しました"
  exit 1
fi

echo ""
echo "=== 2. Firebase にデプロイ ==="
firebase deploy
if [ $? -ne 0 ]; then
  echo "エラー: firebase deploy に失敗しました"
  exit 1
fi

echo ""
echo "=== 完了 ==="
