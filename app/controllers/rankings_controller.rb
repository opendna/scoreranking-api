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
      ranking.merge Ranking.get_ranking(app_id, game_id, rank_type, offset)
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

    myranking = Ranking.get_myranking(app_id, user_id)

    api_result = {'result'=>RESULT_OK}
    api_result.merge(myranking) if myranking
  
    render :json => api_result
  end
end
