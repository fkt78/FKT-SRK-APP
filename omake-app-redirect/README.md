# omake-app.web.app → 正URLへの転送用

このフォルダはアプリ本体ではありません。**旧URLを正URLへ転送するためだけ**の設定です。

| | |
|---|---|
| 正URL（アプリ本体） | https://shucchou-ryohi-seisan.web.app/ |
| 旧URL（このフォルダの対象） | https://omake-app.web.app/ → 上へ301転送 |

## 経緯

2026年8月1日、一時的に `omake-app.web.app`（omake-app プロジェクトのデフォルトサイト）へ
アプリ本体をデプロイしてしまったため、そちらを見ている人が出ないよう転送を置いています。

## 転送の更新が必要になったら

アプリ本体とは**別プロジェクト**（omake-app）なので、デプロイもこのフォルダから個別に行います。

```bash
cd ~/（有）吹田総業/CONV-APP/CONV-SYUTTYOU-APP/omake-app-redirect && firebase deploy --only hosting --project omake-app
```

通常のアプリ更新でこのフォルダを触る必要はありません。アプリ本体のデプロイは
[../デプロイ手順.md](../デプロイ手順.md) を参照してください。

## 注意

`omake-app` は omake-app プロジェクトの**デフォルトサイト**です。将来このURLを別用途で
使いたくなった場合は、この転送設定を先に外してください。
同プロジェクト内の `keihi-kanri.web.app`（経費管理アプリ）には影響しません。
