#encoding: utf-8

#
# スコア
#
class Score
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :app_id, :game_id, :user_id, :score
  
  validates_presence_of :app_id, :game_id, :user_id, :score
  validates :app_id, :numericality => :only_integer
  validates :game_id, :numericality => :only_integer
  validates :user_id, :numericality => :only_integer
  validates :score, :numericality => {:greater_than_or_equal_to => 0}

  TABLE_NAME_FORMAT = "score__%d_%d" # score_[app_id]_[game_id]
  CACHE_KEY_FORMAT  = "score__%d_%d" # score_[app_id]_[game_id]_[user_id]

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  def persisted?
    false
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
  def save
    table_name = sprintf(TABLE_NAME_FORMAT, self.app_id, self.game_id);
    create_table_if_need(table_name)

    sql =<<-EOS
      insert into #{table_name}(user_id, score) values(#{self.user_id}, #{self.score});
    EOS
    ActiveRecord::Base.connection.execute sql
  end

  #
  # スコアを削除する
  #
  def delete
    table_name = sprintf(TABLE_NAME_FORMAT, self.app_id, self.game_id);
    sql =<<-EOS
      delete from #{table_name} where user_id = #{self.user_id};
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

  #
  # game_id抽出
  #
  def self.get_game_id(table_name)
    table_name.split('__').split('_')[1].to_i
  end
end