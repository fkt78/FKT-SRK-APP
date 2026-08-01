# GitHub への保存について

このフォルダは **https://github.com/fkt78/FKT-SRK-APP** に接続済みです。
設定は済んでいるので、初期化やリモート登録をやり直す必要はありません。

```
フォルダ  : ~/（有）吹田総業/CONV-APP/CONV-SYUTTYOU-APP
リポジトリ: https://github.com/fkt78/FKT-SRK-APP
ブランチ  : main
```

---

## 通常はこれだけ

`デプロイ.sh` が **GitHub へのプッシュまで自動で行います。** 別途プッシュする必要はありません。

```bash
cd ~/（有）吹田総業/CONV-APP/CONV-SYUTTYOU-APP && ./デプロイ.sh
```

詳しくは [デプロイ手順.md](デプロイ手順.md) を参照してください。

> **`githubにプッシュ.sh` は使わないでください。**
> プッシュだけを行うとバージョン番号とデプロイ日時が更新されず、
> 公開中のアプリとリポジトリの内容が食い違います。

---

## 公開せずに GitHub にだけ保存したいとき

書きかけの状態を退避しておきたい場合など、デプロイせず記録だけ残したいときに使います。

```bash
cd ~/（有）吹田総業/CONV-APP/CONV-SYUTTYOU-APP
git add -A
git commit -m "作業中: 内容をここに書く"
git push
```

この場合バージョンは上がりません。公開に反映するときに `./デプロイ.sh` を実行してください。

---

## 状態を確認したいとき

```bash
cd ~/（有）吹田総業/CONV-APP/CONV-SYUTTYOU-APP && git status -sb
```

- `## main...origin/main` だけ表示 … GitHub と一致しています
- `ahead 1` などが付く … ローカルに未プッシュのコミットがあります。`git push` で反映
- ファイル名が並ぶ … 保存していない変更があります

直近の履歴を見るには次を実行します。

```bash
cd ~/（有）吹田総業/CONV-APP/CONV-SYUTTYOU-APP && git log --oneline -10
```

---

## うまくいかないとき

### 「Support for password authentication was removed」

パスワードではなく **Personal Access Token** が必要です。
GitHub → Settings → Developer settings → Personal access tokens でトークンを作成し、
パスワードの入力欄にそのトークンを貼り付けてください。

### 「remote: Permission to fkt78/FKT-SRK-APP denied」

ログインしているアカウントに書き込み権限があるか確認してください。
自分用のリポジトリなら、アカウントが `fkt78` になっているか確認します。

### 「Updates were rejected because the remote contains work...」

GitHub 側に、手元にないコミットがある状態です。先に取り込んでからプッシュします。

```bash
cd ~/（有）吹田総業/CONV-APP/CONV-SYUTTYOU-APP
git pull origin main --rebase
git push origin main
```

競合が出た場合は、表示されたファイルを直してから
`git add .` → `git rebase --continue` → `git push origin main` の順に実行します。

### 「Permission denied」など書き込みエラー

**ターミナル.app** など、エディタの外で開いたターミナルで実行してください。

---

## やってはいけないこと

以前このファイルに載っていた手順のうち、次の2つは**実行しないでください。**

- **`rm -rf .git` してから `git init` し直す**
  … これまでの履歴がすべて消えます。このフォルダは既に正しく設定済みなので、
  やり直す理由はありません。

- **`git push --force`**
  … GitHub 側の履歴を上書きして消します。前項の rebase で解決できます。
