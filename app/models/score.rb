#encoding: utf-8

#
# スコア
#
class Score

  TABLE_NAME_FORMAT = "score__%d_%d" # score_[app_id]_[game_id]
  CACHE_KEY_FORMAT  = "score__%d_%d" # score_[app_id]_[game_id]_[user_id]

  #
  # テーブルが存在しない場合は作成する
  #
  def self.create_table(app_id, game_id)
    table_name = sprintf(TABLE_NAME_FORMAT, app_id, game_id)

    Rails.cache.fetch("exists_score_table__" + table_name) do
      sql =<<-EOS
        create table if not exists #{table_name} (
          user_id integer not null,
          score float not null,
          inserted_at timestamp default current_timestamp()
        );
      EOS
      ActiveRecord::Base.connection.execute sql
      true
    end
  end
  
  #
  # スコアを登録する
  #
  def self.insert(app_id, game_id, user_id, score)
    table_name = sprintf(TABLE_NAME_FORMAT, app_id, game_id);
    sql =<<-EOS
      insert into #{table_name}(user_id, score) values(#{user_id}, #{score});
    EOS
    ActiveRecord::Base.connection.execute sql
  end

  #
  # スコアを削除する
  #
  def self.delete(app_id, game_id, user_id)
    table_name = sprintf(TABLE_NAME_FORMAT, app_id, game_id);
    sql =<<-EOS
      delete from #{table_name} where user_id = #{user_id};
    EOS
    ActiveRecord::Base.connection.execute sql
  end

  #
  #　テーブル定義を取得する
  #
  def self.get_tablename_list(app_id)
    sql =<<-EOS
          select table_name from information_schema.tables where table_name like 'score_#{app_id}%';
        EOS
    return ActiveRecord::Base.connection.select(sql)
  end
end