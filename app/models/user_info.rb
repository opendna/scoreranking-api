#encoding: utf-8

#
# ユーザ情報
#
class UserInfo
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :app_id, :user_id, :user_data
  
  validates_presence_of :app_id, :user_id, :user_data
  validates :app_id, :numericality => :only_integer
  validates :user_id, :numericality => :only_integer
  validates_length_of :user_data, maximum:512

  TABLE_NAME_FORMAT = "userinfo_%d"     # userinfo_[app_id]
  CACHE_KEY_FORMAT  = "userinfo_%d_%d"  # userinfo_[app_id]_[user_id]

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  def persisted?
    false
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
    table_name = sprintf(TABLE_NAME_FORMAT, app_id)
    create_table_if_need table_name

    sql =<<-EOS
      insert into #{table_name}(user_id, user_data) values(#{self.user_id}, '#{self.user_data}') on duplicate key
      update user_data = '#{self.user_data}';
    EOS
    ActiveRecord::Base.connection.execute sql
  
    # cacheを更新する
    key = sprintf(CACHE_KEY_FORMAT, self.app_id, self.user_id)
    Rails.cache.write(key, self.user_data)
  end

  #
  # ユーザ情報を検索する
  #
  def self.find(app_id, user_id)
    key = sprintf(CACHE_KEY_FORMAT, app_id, user_id)
    
    userinfo = Rails.cache.fetch(key) do
      table_name = sprintf(TABLE_NAME_FORMAT, app_id);
      sql =<<-EOS
        select user_data from #{table_name} where user_id = #{user_id}
      EOS
      userinfo = ActiveRecord::Base.connection.select_one sql
    end
    userinfo
  end
end