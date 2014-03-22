#encoding: utf-8

#
# マイランキング
#
class Myranking
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :app_id, :user_id, :game_id, :score, :rank, :total
  
  validates_presence_of :app_id, :user_id, :game_id, :score, :rank, :total
  validates :app_id, :numericality => :only_integer
  validates :user_id, :numericality => :only_integer
  validates :game_id, :numericality => :only_integer
  validates :score, :numericality => {:greater_than_or_equal_to => 0}
  validates :rank, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0}
  validates :total, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0}

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  def persisted?
    false
  end

  #
  # テーブル名
  #
  def self.table(app_id, version, user_id)
    "myrank__#{app_id}_#{version}_#{user_id}"
  end

  def table(version)
    Myranking.table(self.app_id, version, self.user_id)
  end
  
  #
  # マイランキングデータ追加
  #
  def save(version)
    data = Rails.cache.read(table(version))
    if data
      data.push({:game_id=>self.game_id, :score=>self.score, :rank=>self.rank, :total=>self.total})
      Rails.cache.write(table(version), data)
    else
      Rails.cache.write(table(version), [{:game_id=>self.game_id, :score=>self.score, :rank=>self.rank, :total=>self.total}])
    end
  end

  #
  # マイランキングデータ取得
  #
  def self.get_ranking(condition)
    version = Version.current(condition.app_id)
    Rails.cache.read(table(condition.app_id, version, condition.user_id))
  end
end