# FKT-SRK-APP を GitHub に保存する手順

このフォルダ（出張日当管理アプリ）の内容を  
**https://github.com/fkt78/FKT-SRK-APP** に保存する手順です。

---

## クイック実行（コピペ用）

**ターミナル.app** を開き、以下を **まとめてコピーして貼り付けて Enter** してください。

```bash
cd "/Users/fukitakatsumi/Desktop/（有）吹田総業/アプリバックアップフォルダ/おまけ/出張日当管理アプリ" && \
rm -rf .git 2>/dev/null; git init && git branch -M main && \
git add . && git commit -m "出張日当管理アプリ（出張旅費精算・PWA）を追加・更新" && \
git remote remove origin 2>/dev/null; git remote add origin https://github.com/fkt78/FKT-SRK-APP.git && \
git push -u origin main
```

- 初回は GitHub の認証（ユーザー名 + Personal Access Token）を聞かれる場合があります。
- すでにリポジトリがある場合は、上記の `git commit` で「nothing to commit」と出ることがあります。そのときは `git push origin main` だけ実行すればOKです。

---

## 方法A: このフォルダをそのままリポジトリにしてプッシュする

**ターミナル（Terminal.app など）** を開き、次のコマンドを **順番に** 実行してください。

```bash
# 1. このフォルダに移動
cd "/Users/fukitakatsumi/Desktop/（有）吹田総業/アプリバックアップフォルダ/おまけ/出張日当管理アプリ"

# 2. まだ git リポジトリでない場合は初期化（既に .git がある場合はスキップして 3 へ）
git init

# 3. ブランチ名を main にする（必要な場合）
git branch -M main

# 4. 全ファイルを追加
git add .

# 5. 初回コミット
git commit -m "出張日当管理アプリ（出張旅費精算）を追加"

# 6. リモートを追加（まだの場合）
git remote add origin https://github.com/fkt78/FKT-SRK-APP.git

# すでに別のリモートが入っている場合は、先に削除してから追加
# git remote remove origin
# git remote add origin https://github.com/fkt78/FKT-SRK-APP.git

# 7. GitHub にプッシュ（初回は -u 付き）
git push -u origin main
```

- GitHub にログインしていない場合は、プッシュ時に **ユーザー名** と **パスワード（または Personal Access Token）** の入力が求められます。
- パスワードは **Personal Access Token** を使う必要があります（通常のパスワードは使えません）。  
  GitHub → Settings → Developer settings → Personal access tokens で発行できます。

---

## 方法B: 既存の FKT-SRK-APP リポジトリに「中身だけ」合わせる

GitHub にすでに FKT-SRK-APP リポジトリがあり、**その中身をこのフォルダの内容で上書きしたい**場合は、次のようにします。

```bash
# 1. ホームなど、作業用の場所に移動
cd /Users/fukitakatsumi

# 2. リポジトリをクローン
git clone https://github.com/fkt78/FKT-SRK-APP.git
cd FKT-SRK-APP

# 3. 出張日当管理アプリのファイルをすべてコピー（上書き）
cp -f "/Users/fukitakatsumi/Desktop/（有）吹田総業/アプリバックアップフォルダ/おまけ/出張日当管理アプリ/"* .
cp -f "/Users/fukitakatsumi/Desktop/（有）吹田総業/アプリバックアップフォルダ/おまけ/出張日当管理アプリ/.gitignore" . 2>/dev/null || true

# 4. 追加・コミット・プッシュ
git add .
git status
git commit -m "出張日当管理アプリの最新版で更新"
git push origin main
```

---

## うまくいかないとき

- **「Permission denied」など書き込みエラー**  
  → ターミナルを **「ターミナル.app」など、Cursor の外で開いたもの** で実行してください。

- **「remote: Permission to fkt78/FKT-SRK-APP denied」**  
  → GitHub にログインしているアカウントに、fkt78/FKT-SRK-APP の書き込み権限があるか確認してください。自分用リポジトリなら、ログインアカウントが fkt78 か確認してください。

- **「Support for password authentication was removed」**  
  → パスワードの代わりに **Personal Access Token** を使う必要があります。  
  GitHub → Settings → Developer settings → Personal access tokens でトークンを作成し、パスワードの入力欄にそのトークンを貼り付けてください。
