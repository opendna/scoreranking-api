#encoding: utf-8

#
# ランキング取得API
#
class RankingsController < ApplicationController

  #
  # ランキング取得
  # GET /ranking
  def ranking
    condition = RankingParameter.new({
      :app_id => params[:app_id], :game_id => params[:game_id], :rank_type => params[:rank_type],
      :offset => params[:offset], :limit => params[:limit]})
    
    if condition.valid?
      rankings = Ranking.get_ranking(condition)
      api_result = {'result'=>RESULT_OK}
      api_result.merge!(rankings) if rankings
      render :json => api_result
    else
      render :json => {'result'=>RESULT_NG}
    end
  end

  #
  # マイランキング取得
  # GET /my_ranking
  def my_ranking
    condition = MyrankingParameter.new({:app_id => params[:app_id], :user_id => params[:user_id]})

    if condition.valid?
      myranking = Myranking.get_ranking(condition)
      api_result = {'result'=>RESULT_OK, 'myranking'=>myranking}
      render :json => api_result
    else
      render :json => {'result'=>RESULT_NG}
    end
  end
end
