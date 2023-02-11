# Overview
- Sinatra を用いて作成したシンプルなメモアプリです

## Goal
Railsという巨大なフレームワークで開発する前に、シンプルなWebフレームワークSinatraでWeb開発の基礎を学ぶ

## Function
- メモの作成、編集、削除ができます
- 作成したメモはメモは一覧で表示できます

# URI設計
|Method|Path|Description|
|:---|:---|:---|
|GET|/memos|メモ一覧を取得|
|GET|/memos/new|メモ作成画面|
|GET|/memos/memo_id|メモ詳細画面|
|GET|/memos/memo_id/edit|メモ変更画面|
|POST|/memos|メモを作成する|
|PATCH|/memos/memo_id|メモの内容を変更する|
|DELETE|/memos/memo_id|メモを削除する|

# ローカルでアプリケーションを立ち上げるための手順
```
# ローカルに複製
% git clone https://github.com/MikotoMakizuru/my-sinatra.git

# ディレクトリへ移動
% cd my-sinatra

# 必要な gem をインストール
% bundle install

# アプリケーション起動
% bundle exec ruby app.rb

```
以下のURLにアクセスして表示
http://127.0.0.1:4567/
