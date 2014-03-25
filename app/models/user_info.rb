#encoding: utf-8

#
# ユーザ情報
#
class UserInfo < NonPersistedModel

  attr_accessor :app_id, :user_id, :user_data
  
  validates_presence_of :app_id, :user_id, :user_data
  validates :app_id, :numericality => :only_integer
  validates :user_id, :numericality => :only_integer
  validates_length_of :user_data, maximum:512

  def table
    UserInfo.table(self.app_id)
  end
  def self.table(app_id)
    "userinfo_#{app_id}"
  end

  def cache_key
    UserInfo.cache_key(self.app_id, self.user_id)
  end
  def self.cache_key(app_id, user_id)
    "userinfo__#{app_id}__#{user_id}"
  end

  #
  # テーブルを作成する
  #
  def create_table_if_need(table_name)
    Rails.cache.fetch("exists_score_table__" + table_name) do
      sql =<<-EOS
        create table if not exists #{table_name} (
          user_id integer not null primary key,
          user_data text
        );
      EOS
      ActiveRecord::Base.connection.execute sql
      true
    end
  end

  #
  # ユーザ情報を登録する
  #
  def save
    create_table_if_need table()

    sql =<<-EOS
      insert into #{table()}(user_id, user_data) values(#{self.user_id}, '#{self.user_data}') on duplicate key
      update user_data = '#{self.user_data}';
    EOS
    ActiveRecord::Base.connection.execute sql
  
    # cacheを更新する
    Rails.cache.write(cache_key(), self.user_data)
  end

  #
  # ユーザ情報を検索する
  #
  def self.find(app_id, user_id)
    userinfo = Rails.cache.fetch(self.cache_key(app_id, user_id)) do
      sql =<<-EOS
        select user_data from #{self.table(app_id, user_id)} where user_id = #{user_id}
      EOS
      userinfo = ActiveRecord::Base.connection.select_one sql
    end
    userinfo
  end
end