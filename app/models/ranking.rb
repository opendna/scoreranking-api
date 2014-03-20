#encoding: utf-8
require 'cache'

#
# ランキング
#
class Ranking
  include Cache

  # バージョン管理
  CURRENT_VERSION_CACHE_KEY = "current_version"
  
  RANKING_CACHE_KEY_FORMAT = "rank_%d_%d_%d_%d_%d" # rank_[app_id]_[game_id]_[rank_type]_[version]_[no]
  MYRANKING_CACHE_KEY_FORMAT = "myrank_%d_%d" # myrank_[app_id]_[version]

  #
  #
  #
  def self.get_ranking(app_id, game_id, rank_type, no)
    # ランキングデータ
    ranking_data_key = sprintf(RANKING_CACHE_KEY_FORMAT, app_id, game_id, rank_type, ranking_current_version(), no);
    ranking_data = find_from_cache(ranking_data_key)
    
    if (ranking_data)
      # ユーザ情報をマージ
      user_id = ranking_data['user_id']
      userinfo_key = sprintf(USERINFO_CACHE_KEY_FORMAT, app_id, user_id)
      userinfo = find_from_cache(userinfo_key)
      if (userinfo) 
        ranking_data.merge userinfo
      end

      return {no => ranking_data}
    else
      return {no => {}}
    end
  end

  #
  #
  #
  def self.get_myranking(app_id, user_id)
    # ランキングデータ
    ranking_data_key = sprintf(MYRANKING_CACHE_KEY_FORMAT, app_id, ranking_current_version(), user_id);
    return find_from_cache(ranking_data_key)
  end

  #
  # 現在のバージョンを取得
  #
  def self.ranking_current_version
    current_version = find_from_cache(CURRENT_VERSION_CACHE_KEY)

    unless current_version
      # バージョンがない場合は初期化 version=1
      current_version = 1
      save_to_cache(CURRENT_VERSION_CACHE_KEY, current_version)
    end

    return current_version
  end
end