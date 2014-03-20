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
    
    create_table(app_id, game_id)
    _save(app_id, game_id, user_id, score)
  
    render :json => {'result'=>RESULT_OK}
  end

  #
  #
  # PUT /scores
  def bulk_save
    app_id = params[:app_id]
    datas = params[:datas]
    
    datas.map do |key, data|
      _save(app_id, data['game_id'], data['user_id'], data['score'])
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

    _delete(app_id, game_id, user_id)
    
    render :json => {'result'=>RESULT_OK}
  end

  #
  #
  # DELETE /scores
  def bulk_delete
    app_id = params[:app_id]
    datas = params[:datas]

    datas.map do |key, data|
      _delete(app_id, data['game_id'], data['user_id'])
    end

    render :json => {'result'=>RESULT_OK}
  end

  private
  #
  #
  #
  def create_table(app_id, game_id)
    #　TODO テーブルあるか？チェック、無ければCreate

    table_name = sprintf(SCORE_TABLE_NAME_FORMAT, app_id, game_id)
    sql =<<-EOS
      create table if not exists #{table_name} (
        user_id integer not null,
        score integer not null,
        inserted_at timestamp default current_timestamp()
      );
    EOS
    ActiveRecord::Base.connection.execute sql
  end
  
  #
  #
  #
  def _save(app_id, game_id, user_id, score)
    table_name = sprintf(SCORE_TABLE_NAME_FORMAT, app_id, game_id);
    sql =<<-EOS
      insert into #{table_name}(user_id, score) values(#{user_id}, #{score});
    EOS
    ActiveRecord::Base.connection.execute sql
  end

  #
  #
  #
  def _delete(app_id, game_id, user_id)
    #　TODO テーブルがなければ無視

    table_name = sprintf(SCORE_TABLE_NAME_FORMAT, app_id, game_id);
    sql =<<-EOS
      delete from #{table_name} where user_id = #{user_id};
    EOS
    ActiveRecord::Base.connection.execute sql
  end
end