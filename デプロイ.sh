#!/bin/bash
# 出張旅費精算アプリ
# バージョンを上げ、デプロイ日時を埋め込んで、Firebase と GitHub に反映するスクリプト
#
# 使い方:
#   ./デプロイ.sh                    パッチを上げる   1.0.0 → 1.0.1  ← 通常はこれ
#   ./デプロイ.sh patch              同上（不具合の修正・文言の調整など）
#   ./デプロイ.sh minor              マイナーを上げる 1.0.1 → 1.1.0  （機能追加）
#   ./デプロイ.sh major              メジャーを上げる 1.1.0 → 2.0.0  （大きな作り替え）
#   ./デプロイ.sh keep               バージョンは据え置き、日時だけ更新
#
#   ./デプロイ.sh patch "月送りの修正"   コミットメッセージを添える

set -e
cd "$(dirname "$0")"

PROJECT="new-check-137f9"
URL="https://shucchou-ryohi-seisan.web.app/"
BUMP="${1:-patch}"
NOTE="${2:-}"

# --- 現在のバージョンを読み取る ---
CURRENT=$(grep -o "const APP_VERSION = '[^']*'" index.html | head -1 | sed "s/.*'\(.*\)'/\1/")
if [ -z "$CURRENT" ]; then
  echo "エラー: index.html から現在のバージョンを読み取れませんでした。"
  echo "       const APP_VERSION = '...' の行が壊れていないか確認してください。"
  exit 1
fi

IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT"

case "$BUMP" in
  major) MAJOR=$((MAJOR + 1)); MINOR=0; PATCH=0 ;;
  minor) MINOR=$((MINOR + 1)); PATCH=0 ;;
  patch) PATCH=$((PATCH + 1)) ;;
  keep)  ;;
  *)
    echo "エラー: 1つ目の引数は major / minor / patch / keep のいずれかです（指定: $BUMP）"
    echo "       例: ./デプロイ.sh minor \"日当の種類を追加\""
    exit 1
    ;;
esac

NEW="$MAJOR.$MINOR.$PATCH"
STAMP=$(date '+%Y/%m/%d %H:%M')

echo "=== 出張旅費精算アプリ デプロイ ==="
echo "  バージョン  : $CURRENT → $NEW   ($BUMP)"
echo "  デプロイ日時: $STAMP"
echo "  デプロイ先  : $URL"
echo "  プロジェクト: $PROJECT"
echo ""
read -p "この内容で進めますか? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "キャンセルしました。"
  exit 0
fi

# --- 1. バージョンとデプロイ日時を埋め込む ---
BAK=$(mktemp -d)
cp index.html sw.js "$BAK/"
restore() { cp "$BAK/index.html" index.html; cp "$BAK/sw.js" sw.js; }

echo ""
echo "=== 1. バージョンを埋め込み ==="
sed -i '' "s/const APP_VERSION = '[^']*'/const APP_VERSION = '$NEW'/" index.html
sed -i '' "s|const DEPLOYED_AT = '[^']*'|const DEPLOYED_AT = '$STAMP'|" index.html
sed -i '' "s/const CACHE_NAME = '[^']*'/const CACHE_NAME = 'fkt-srk-app-v$NEW'/" sw.js

if ! grep -q "const APP_VERSION = '$NEW'" index.html \
  || ! grep -q "const DEPLOYED_AT = '$STAMP'" index.html \
  || ! grep -q "const CACHE_NAME = 'fkt-srk-app-v$NEW'" sw.js; then
  restore
  rm -rf "$BAK"
  echo "エラー: バージョンの書き込みに失敗しました。ファイルは元に戻しました。"
  exit 1
fi
echo "  v$NEW / $STAMP を index.html と sw.js に書き込みました"

# --- 2. Firebase にデプロイ ---
echo ""
echo "=== 2. Firebase にデプロイ ==="
if ! firebase deploy --only hosting --project "$PROJECT"; then
  restore
  rm -rf "$BAK"
  echo ""
  echo "エラー: デプロイに失敗しました。バージョンは元に戻したので、"
  echo "       原因を直してからもう一度実行してください。"
  exit 1
fi

# --- 3. GitHub に反映 ---
echo ""
echo "=== 3. GitHub に反映 ==="
git add -A
if git diff --cached --quiet; then
  echo "  コミットする変更はありませんでした"
else
  if [ -n "$NOTE" ]; then
    git commit -m "v$NEW $NOTE ($STAMP)"
  else
    git commit -m "v$NEW をデプロイ ($STAMP)"
  fi
  git push
fi

rm -rf "$BAK"

echo ""
echo "=== 完了 ==="
echo "  v$NEW  ($STAMP)"
echo "  $URL"
