#encoding: utf-8
require 'cache'
include Cache

#
# ランキング
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
    p key
    Cache.save(key, "#{rank},#{user_id},#{score}")
  end

  #
  #
  #
  def self.get_ranking(app_id, game_id, rank_type, no)
    # ランキングデータ
    key = sprintf(RANKING_CACHE_KEY_FORMAT, app_id, game_id, rank_type, current_version(), no);
    ranking_data = Cache.find(key)
    
    if (ranking_data)
      # ユーザ情報をマージ
      user_id = ranking_data['user_id']
      userinfo_key = sprintf(USERINFO_CACHE_KEY_FORMAT, app_id, user_id)
      userinfo = Cache.find(userinfo_key)
      if (userinfo) 
        ranking_data.merge userinfo
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
    p key
    if Cache.find(key)
      Cache.append(key, "#{game_id},#{rank},#{score}#{DATA_DELEMITER}")
    else
      Cache.save(key, "#{game_id},#{rank},#{score}#{DATA_DELEMITER}")
    end
  end

  #
  #
  #
  def self.get_myranking(app_id, user_id)
    # ランキングデータ
    key = sprintf(MYRANKING_CACHE_KEY_FORMAT, app_id, current_version(), user_id);
    return Cache.find(key)
  end

  #
  # 現在のバージョンを取得
  #
  def self.current_version
    current_version = Cache.get_raw(CURRENT_VERSION_CACHE_KEY)

    unless current_version
      # バージョンがない場合は初期化 version=0
      current_version = 0
      Cache.set_raw(CURRENT_VERSION_CACHE_KEY, current_version)
    end

    return current_version
  end
  
  #
  #
  #
  def self.update_version
    Cache.incr(CURRENT_VERSION_CACHE_KEY)
  end
  
end