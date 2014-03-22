#encoding: utf-8

#
# スコア記録API
#
class ScoresController < ApplicationController

  #
  # スコア記録
  # PUT /score
  def save
    @score = Score.new({:app_id => params[:app_id], :game_id => params[:game_id], :user_id => params[:user_id], :score => params[:score]})

    if @score.valid?
      @score.save
    else
      render :json => {'result'=>RESULT_NG} and return
    end   

    render :json => {'result'=>RESULT_OK}
  end

  #
  # スコア記録
  # PUT /scores
  def bulk_save
    app_id = params[:app_id]
    datas = params[:datas]

    datas.each_value do |data|
      @score = Score.new({:app_id => app_id, :game_id => data[:game_id], :user_id => data[:user_id], :score => data[:score]})
      if @score.valid?
        @score.save
      else
        render :json => {'result'=>RESULT_NG} and return
      end
    end

    render :json => {'result'=>RESULT_OK}
  end

  #
  # スコア削除
  # DELETE /score
  def delete
    @score = Score.new({:app_id => params[:app_id], :game_id => params[:game_id], :user_id => params[:user_id], :score => 0})

    if @score.valid?
      @score.delete
    else
      render :json => {'result'=>RESULT_NG} and return
    end

    render :json => {'result'=>RESULT_OK}
  end

  #
  # スコア削除
  # DELETE /scores
  def bulk_delete
    app_id = params[:app_id]
    datas = params[:datas]

    datas.each_value do |data|
      @score = Score.new({:app_id => app_id, :game_id => data[:game_id], :user_id => data[:user_id], :score => 0})
      if @score.valid?
        @score.delete
      else
        render :json => {'result'=>RESULT_NG} and return
      end
    end

    render :json => {'result'=>RESULT_OK}
  end
end
