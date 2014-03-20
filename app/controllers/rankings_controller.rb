#encoding: utf-8

#
# ランキング取得API
#
class RankingsController < ApplicationController

  #
  # ランキング取得
  # GET /ranking
  def ranking
    app_id = params[:app_id]
    game_id = params[:game_id]
    rank_type = params[:rank_type]
    offset = params[:offset].to_i
    limit = params[:limit].to_i
    
    ranking = {}
    limit.times do
      ranking.merge get_ranking(app_id, game_id, rank_type, offset)
      offset += 1
    end

    api_result = {'result'=>RESULT_OK}
    api_result.merge(ranking) if ranking

    render :json => api_result
  end
  
  #
  # マイランキング取得
  # GET /my_ranking
  def my_ranking
    app_id = params[:app_id]
    user_id = params[:user_id]

    myranking = get_myranking(app_id, user_id)

    api_result = {'result'=>RESULT_OK}
    api_result.merge(myranking) if myranking
  
    render :json => api_result
  end

  private

  #
  #
  #
  def get_ranking(app_id, game_id, rank_type, no)
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
  def get_myranking(app_id, user_id)
    # ランキングデータ
    ranking_data_key = sprintf(MYRANKING_CACHE_KEY_FORMAT, app_id, ranking_current_version(), user_id);
    return find_from_cache(ranking_data_key)
  end

  #
  # 現在のバージョンを取得
  #
  def ranking_current_version
    current_version = find_from_cache(CURRENT_VERSION_CACHE_KEY)

    unless current_version
      # バージョンがない場合は初期化 version=1
      current_version = 1
      save_to_cache(CURRENT_VERSION_CACHE_KEY, current_version)
    end

    return current_version
  end
end
