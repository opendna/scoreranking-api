#encoding: utf-8
require 'cache'
include Cache

#
# ランキング／マイランキング
#
class Ranking

  # バージョン管理
  CURRENT_VERSION_CACHE_KEY = "current_version"
    
  RANKING_CACHE_KEY_FORMAT = "rank_%d_%d_%d_%d_%d" # rank_[app_id]_[game_id]_[rank_type]_[version]_[no]
  MYRANKING_CACHE_KEY_FORMAT = "myrank_%d_%d_%d" # myrank_[app_id]_[version]_[user_id]
  DATA_DELEMITER = "|"

  #
  # ランキングデータ追加
  #
  def self.insert_ranking(app_id, game_id, rank_type, version, no, rank, user_id, score)
    key = sprintf(RANKING_CACHE_KEY_FORMAT, app_id, game_id, rank_type, version, no);
    Rails.logger.debug "insert_ranking:#{key}"
    Cache.set(key, "#{rank},#{user_id},#{score}")
  end

  #
  # ランキング取得
  #
  def self.get_ranking(app_id, game_id, rank_type, no)
    key = sprintf(RANKING_CACHE_KEY_FORMAT, app_id, game_id, rank_type, current_version(), no);
    ranking_data = Cache.get(key)

    if (ranking_data)
      # ユーザ情報をマージ
      user_id = ranking_data.split(',')[1].to_i
      userinfo = UserInfo.find(app_id, user_id)
      if (userinfo) 
        ranking_data = "#{ranking_data}#{DATA_DELEMITER}#{userinfo}"
      end
      return {no => ranking_data}
    else
      return {no => {}}
    end
  end

  #
  # マイランキングデータ追加
  #
  def self.insert_myranking(app_id, version, user_id, game_id, rank, score)
    key = sprintf(MYRANKING_CACHE_KEY_FORMAT, app_id, version, user_id);
    Rails.logger.debug "insert_myranking:#{key}"
    Cache.append(key, "#{game_id},#{rank},#{score}#{DATA_DELEMITER}")
  end

  #
  # マイランキングデータ取得
  #
  def self.get_myranking(app_id, user_id)
    key = sprintf(MYRANKING_CACHE_KEY_FORMAT, app_id, current_version(), user_id);
    return Cache.get(key)
  end

  #
  # 現在のバージョンを取得
  #
  def self.current_version
    current_version = Cache.get(CURRENT_VERSION_CACHE_KEY)

    unless current_version
      # バージョンがない場合は初期化 version=0
      current_version = 0
      Cache.set(CURRENT_VERSION_CACHE_KEY, current_version)
    end

    return current_version
  end
  
  #
  # ランキングバージョンを更新
  #
  def self.update_version
    Cache.incr(CURRENT_VERSION_CACHE_KEY)
  end
end