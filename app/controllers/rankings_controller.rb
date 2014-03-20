#encoding: utf-8

class RankingsController < ApplicationController
  include Cache

  #
  #
  #
  def ranking
    app_id = params[:app_id]
    game_id = params[:game_id]
    rank_type = params[:rank_type]
    offset = params[:offset]
    limit = params[:limit]
   
    render :json => {'result'=>RESULT_OK}
  end
  
  #
  #
  #
  def my_ranking
    app_id = params[:app_id]
    user_id = params[:user_id]

    render :json => {'result'=>RESULT_OK}
  end

  private
  
end
