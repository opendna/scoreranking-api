#encoding: utf-8
require 'cache'

#
# ユーザ情報
#
class UserInfo
  include Cache

  TABLE_NAME_FORMAT = "userinfo_%d"     # userinfo_[app_id]
  CACHE_KEY_FORMAT  = "userinfo_%d_%d"  # userinfo_[app_id]_[user_id]

  #
  # テーブルを作成する
  #
  def self.create_table(app_id)
    table_name = sprintf(TABLE_NAME_FORMAT, app_id);
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
  def self.save(app_id, user_id, data)
    table_name = sprintf(TABLE_NAME_FORMAT, app_id);
    sql =<<-EOS
      insert into #{table_name}(user_id, data) values(#{user_id}, '#{data}') on duplicate key
      update data = '#{data}';
    EOS
    ActiveRecord::Base.connection.execute sql
  
    # cacheを更新する
    key = sprintf(CACHE_KEY_FORMAT, app_id, user_id)
    save_to_cache(key, data)
  end

end