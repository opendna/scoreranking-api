#encoding: utf-8
require 'dalli'

class UserInfo < ActiveRecord::Base
  attr_accessible :user_id, :data

  # userinfo_[app_id]
  TABLE_NAME_FORMAT = "userinfo_%d"
  
  # userinfo_[app_id]]_[user_id]
  CACHE_KEY_FORMAT = "userinfo_%d_%d"

  #
  # アプリID_ユーザ情報テーブルを作成する
  #
  def create_table(app_id)
    table_name = sprintf(TABLE_NAME_FORMAT, app_id);
    sql =<<-EOS
      if not exists #{table_name}
      create table #{table_name} (
        user_id int not null,
        data text
      );
    EOS
    
    p sql
    ActiveRecord::Base.connection.execute sql
  end

  #
  # キャッシュからデータを探す
  #
  def find(app_id, user_id)
    userinfo = self.find_in_cache
    return userinfo if (userinfo)

    # キャッシュに見つからない場合はDBからSELECTしてcacheに入れる
    table_name = sprintf(TABLE_NAME_FORMAT, app_id);
    sql =<<-EOS
      select data from #{table_name} where user_id = #{user_id}
    EOS
    
    stmt = ActiveRecord::Base.connection.select_one sql
    result = stmt.execute 
    stmt.close
    return Array.new if (result.nil?)

    data = result[:data]

    self.save_in_cache(app_id, user_id, data)
    
    userinfo = %w(#{user_id} #{data})
    
    return userinfo;
  end
  
  #
  #
  #
  def save(app_id, user_id, data)
    table_name = sprintf(TABLE_NAME_FORMAT, app_id);
    sql =<<-EOS
      insert #{table_name} into values(#{user_id}, #{user_id}) on duplicate key update;
    EOS
    
    ActiveRecord::Base.connection.execute sql
  end
  
  #
  #
  #
  def find_in_cache(app_id, user_id)
    key = sprintf(CACHE_KEY_FORMAT, app_id, user_id)
    client = Dalli::Client.new;
    client.get(key)
  end
  
  #
  #
  #
  def save_in_cache(app_id, user_id, data)
    key = sprintf(CACHE_KEY_FORMAT, app_id, user_id)
    client = Dalli::Client.new;
    client.put(key, data)
  end
end
