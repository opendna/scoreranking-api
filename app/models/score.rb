#encoding: utf-8
require 'cache'

#
# スコア
#
class Score
  #include Cache

  TABLE_NAME_FORMAT = "score_%d_%d" # userinfo_[app_id]_[game_id]
  CACHE_KEY_FORMAT  = "score_%d_%d" # userinfo_[app_id]_[game_id]_[user_id]

  # テーブル名リスト
  TABLENAMELIST_CACHE_KEY_FORMAT = "tablenamelist_%d" # tablenamelist_[app_id]
   TABLENAMELIST_DELEMITER = "|"

  #
  #
  #
  def self.create_table(app_id, game_id)
    table_name = sprintf(TABLE_NAME_FORMAT, app_id, game_id)
    unless exist_table?(app_id, table_name)
      sql =<<-EOS
        create table #{table_name} (
          user_id integer not null,
          score integer not null,
          inserted_at timestamp default current_timestamp()
        );
      EOS
      ActiveRecord::Base.connection.execute sql
      
      # キャッシュにテーブル名を追加
      Cache::append_to_cache(sprintf(TABLENAMELIST_CACHE_KEY_FORMAT, app_id), "#{table_name}#{TABLENAMELIST_DELEMITER}")
    end
  end
  
  #
  #
  #
  def self.save(app_id, game_id, user_id, score)
    table_name = sprintf(TABLE_NAME_FORMAT, app_id, game_id);
    sql =<<-EOS
      insert into #{table_name}(user_id, score) values(#{user_id}, #{score});
    EOS
    ActiveRecord::Base.connection.execute sql
  end

  #
  #
  #
  def self.delete(app_id, game_id, user_id)
    table_name = sprintf(TABLE_NAME_FORMAT, app_id, game_id);
    if exist_table?(app_id, table_name)
      sql =<<-EOS
        delete from #{table_name} where user_id = #{user_id};
      EOS
      ActiveRecord::Base.connection.execute sql
    end
  end
  
  #
  #
  #
  def self.exist_table?(app_id, name)
    tablename_list = Cache::find_from_cache(sprintf(TABLENAMELIST_CACHE_KEY_FORMAT, app_id))

    unless tablename_list
      # 無い場合は作成する
      tablename_list = regist_tablename_list(app_id)
    end
    
    tablenames = tablename_list.split(TABLENAMELIST_DELEMITER)

    return tablenames.include? name
  end
  
  #
  #
  #
  def self.regist_tablename_list(app_id)
    sql =<<-EOS
      select table_name from information_schema.tables where table_name like 'score_#{app_id}%';
    EOS
    tables = ActiveRecord::Base.connection.select(sql)
    
    tablename_list = ""
    tables.each do |tableinfo|
      tablename_list += "#{tableinfo['table_name']}#{TABLENAMELIST_DELEMITER}"
    end

    Cache::save_to_cache(sprintf(TABLENAMELIST_CACHE_KEY_FORMAT, app_id), tablename_list)
    return tablename_list
  end
end