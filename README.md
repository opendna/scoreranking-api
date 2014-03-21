scoreranking-api
================

- ユーザ情報API
- スコア情報API
- ランキングAPI

## ユーザ情報API 
PUT /user_info(app_id,user_id,data)

### 実装詳細
- PUT /user_info

---

1. テーブル名

		table_name = user_info_[app_id]

2. データ登録／更新

		insert [table_name] into values(user_id, data) on duplicate key update;

3. memcachedにキャッシュする

		user_info_[app_id]]_[user_id]のkeyで、dataを保存する


# スコア情報API
PUT /score(app_id,game_id,user_id,score)
DELETE /score(app_id,game_id,user_id)

PUT /scores(app_id, [game_id,user_id,score])
DELETE /scores(app_id, [game_id,user_id])

game_idはアプリケーションごとのフォーマット

	例：タゲトモ

	game_id = "リーグ"+"（四択|タイピング|Part|Section）" + "_Dcode"

### 実装詳細
- PUT /score
- PUT /scores

---

1. テーブル名生成 

		table_name = score_[app_id]_[gameid]
	
2. テーブルの存在チェック

		if not exists [TABLE_DEFINITIONS]
			memcachedにmysqlのテーブルリストをキャッシュ
		return not exists テーブル名 in [TABLE_DEFINITIONS]
	
		※「"TABLE_DEFINITIONS" + テーブル名」のkeyで値が取得できるか？

3. テーブルが無かったら作成

		create table [table_name] (		  user_id integer not null,		  score integer not null,		  created_at timestamp default CURRENT_TIMESTAMP()		);
	
		[TABLE_DEFINITIONS]にテーブル名を追加

4. スコア情報を登録

		insert [table_name] into values(user_id, score);
	
5. scoresの場合は1~4を繰り返す


## ランキングAPI
GET /ranking(app_id,game_id,rank_type,offset,limit)
GET /myranking(app_id,user_id)

### ランキングテーブル(memcached)

|`rank_[app_id]_[game_id]_[rank_type]_[version]_[no]`|
|:---------------------------------------------------|
|rank_no,user_id,score|

|`myrank_[app_id]_[version]_[user_id]`|
|:------------------------------------|
|value(game_id,rank,score|game_id,rank,score|...)|

|`currentversion_[app_id]`|
|:------------------------|
|default 0|

### 実装詳細

- GET /ranking
- GET /myranking

---

1. ランキングを取得

		loop offset to limit
			result += ([memcached][i] + [memcached][userinfo][user_id])
		end
		return result


2. マイランキングを取得

		return [memcached][myrank_appid][user_id]

## ランキング生成バッチ

