#encoding: utf-8

#
# スコア記録API
#
class ScoresController < ApplicationController

  #
  #
  # PUT /score
  def save
    app_id = params[:app_id]
    game_id = params[:game_id]
    user_id = params[:user_id]
    score = params[:score]
    
    Score.create_table(app_id, game_id)
    Score.save(app_id, game_id, user_id, score)
  
    render :json => {'result'=>RESULT_OK}
  end

  #
  #
  # PUT /scores
  def bulk_save
    app_id = params[:app_id]
    datas = params[:datas]

    datas.map do |key, data|
      Score.create_table(app_id, data['game_id'])
      Score.save(app_id, data['game_id'], data['user_id'], data['score'])
    end

    render :json => {'result'=>RESULT_OK}
  end

  #
  #
  # DELETE /score
  def delete
    app_id = params[:app_id]
    game_id = params[:game_id]
    user_id = params[:user_id]

    Score.delete(app_id, game_id, user_id)
    
    render :json => {'result'=>RESULT_OK}
  end

  #
  #
  # DELETE /scores
  def bulk_delete
    app_id = params[:app_id]
    datas = params[:datas]

    datas.map do |key, data|
      Score.delete(app_id, data['game_id'], data['user_id'])
    end

    render :json => {'result'=>RESULT_OK}
  end
end
