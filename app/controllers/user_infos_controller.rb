#encoding: utf-8

#
# ユーザ情報API
#
class UserInfosController < ApplicationController

  #
  # ユーザ情報登録／更新
  # PUT /user_info (app_id,user_id,data)
  def save
    app_id = params[:app_id]
    user_id = params[:user_id]
    data = params[:data]

    create_table(app_id)
    _save(app_id, user_id, data)
  
    render :json => {'result'=>RESULT_OK}
  end

  private

  #
  # テーブルを作成する
  #
  def create_table(app_id)
    table_name = sprintf(USERINFO_TABLE_NAME_FORMAT, app_id);
    sql =<<-EOS
      create table if not exists #{table_name} (
        user_id integer not null primary key,
        data text
      );
    EOS
    ActiveRecord::Base.connection.execute sql
  end

  #
  # ユーザ情報を登録する
  #
  def _save(app_id, user_id, data)
    table_name = sprintf(USERINFO_TABLE_NAME_FORMAT, app_id);
    sql =<<-EOS
      insert into #{table_name}(user_id, data) values(#{user_id}, '#{data}') on duplicate key
      update data = '#{data}';
    EOS
    ActiveRecord::Base.connection.execute sql
  
    # cacheを更新する
    key = sprintf(USERINFO_CACHE_KEY_FORMAT, app_id, user_id)
    save_to_cache(key, data)
  end
end
