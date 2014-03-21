#encoding: utf-8

#
# ユーザ情報
#
class UserInfo

  TABLE_NAME_FORMAT = "userinfo_%d"     # userinfo_[app_id]
  CACHE_KEY_FORMAT  = "userinfo_%d_%d"  # userinfo_[app_id]_[user_id]

  #
  # テーブルを作成する
  #
  def self.create_table(app_id)
    table_name = sprintf(TABLE_NAME_FORMAT, app_id);
    
    Rails.cache.fetch("exists_score_table__" + table_name) do
      sql =<<-EOS
        create table if not exists #{table_name} (
          user_id integer not null primary key,
          data text
        );
      EOS
      ActiveRecord::Base.connection.execute sql
      true
    end
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
    Rails.cache.write(key, data)
  end

  #
  # ユーザ情報を検索する
  #
  def self.find(app_id, user_id)
    key = sprintf(CACHE_KEY_FORMAT, app_id, user_id)
    
    userinfo = Rails.cache.fetch(key) do
      # cacheに見つからない場合はDBからSELECTして
      table_name = sprintf(TABLE_NAME_FORMAT, app_id);
      sql =<<-EOS
        select data from #{table_name} where user_id = #{user_id}
      EOS
      userinfo = ActiveRecord::Base.connection.select_one sql
      unless (userinfo.nil?)
        # cacheに入れておく
        Rails.cache.write(key, userinfo['data'])
      end
    end
    userinfo
  end
end