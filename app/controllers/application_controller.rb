#encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery

  include Cache

  #
  # レスポンスコード
  #
  RESULT_OK = 0

  #
  # スコア
  #
  SCORE_TABLE_NAME_FORMAT = "score_%d_%d" # userinfo_[app_id]_[game_id]
  SCORE_CACHE_KEY_FORMAT  = "score_%d_%d" # userinfo_[app_id]_[game_id]_[user_id]

  #
  # ユーザ
  #
  USERINFO_TABLE_NAME_FORMAT = "userinfo_%d"     # userinfo_[app_id]
  USERINFO_CACHE_KEY_FORMAT  = "userinfo_%d_%d"  # userinfo_[app_id]_[user_id]

  #
  # ランキング
  #
  RANKING_CACHE_KEY_FORMAT = "rank_%d_%d_%d_%d_%d" # rank_[app_id]_[game_id]_[rank_type]_[version]_[no]
  MYRANKING_CACHE_KEY_FORMAT = "myrank_%d_%d" # myrank_[app_id]_[version]

  #
  # バージョン管理
  #
  CURRENT_VERSION_CACHE_KEY = "current_version"
  
end
