#encoding: utf-8

#
# スコア
#
class Score < NonPersistedModel

  attr_accessor :app_id, :game_id, :user_id, :score, :inserted_at
  
  validates_presence_of :app_id, :game_id, :user_id, :score, :inserted_at
  validates :app_id, :numericality => :only_integer
  validates :user_id, :numericality => :only_integer
  validates :score, :numericality => {:greater_than_or_equal_to => 0}
  validates_datetime :inserted_at

  def table
    "score__#{self.app_id}__#{self.game_id}"
  end

  #
  # テーブルが存在しない場合は作成する
  #
  def create_table_if_need(table_name)
    Rails.cache.fetch("exists_score_table__" + table_name) do
      sql =<<-EOS
        create table if not exists #{table_name} (
          user_id integer not null,
          score float not null,
          inserted_at timestamp not null
        );
      EOS
      ActiveRecord::Base.connection.execute sql
      true
    end
  end
  
  #
  # スコアを登録する
  #
  def save
    create_table_if_need(table())

    sql =<<-EOS
      insert into #{table()}(user_id, score, inserted_at) values(#{self.user_id}, #{self.score}, '#{self.inserted_at}');
    EOS
    ActiveRecord::Base.connection.execute sql
  end

  #
  # スコアを削除する
  #
  def delete
    sql =<<-EOS
      delete from #{table()} where user_id = #{self.user_id};
    EOS
    ActiveRecord::Base.connection.execute sql
  end

  #
  #　テーブル定義を取得する
  #
  def self.get_tablename_list(app_id)
    config = Rails.configuration.database_configuration
    database = config[Rails.env]["database"]

    sql =<<-EOS
          select table_name from information_schema.tables where TABLE_SCHEMA = "#{database}" and table_name like 'score__#{app_id}%';
        EOS
    return ActiveRecord::Base.connection.select(sql)
  end

  #
  # game_id抽出
  #
  def self.get_game_id(table_name)
    table_name.split('__')[2]
  end
end