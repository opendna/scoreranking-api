#encoding: utf-8
require 'cache'

#
# スコア
#
class Score
  include Cache

  TABLE_NAME_FORMAT = "score_%d_%d" # userinfo_[app_id]_[game_id]
  CACHE_KEY_FORMAT  = "score_%d_%d" # userinfo_[app_id]_[game_id]_[user_id]

  #
  #
  #
  def self.create_table(app_id, game_id)
    #　TODO テーブルあるか？チェック、無ければCreate

    table_name = sprintf(TABLE_NAME_FORMAT, app_id, game_id)
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
    #　TODO テーブルがなければ無視

    table_name = sprintf(TABLE_NAME_FORMAT, app_id, game_id);
    sql =<<-EOS
      delete from #{table_name} where user_id = #{user_id};
    EOS
    ActiveRecord::Base.connection.execute sql
  end
end