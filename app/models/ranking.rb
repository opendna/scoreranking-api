#encoding: utf-8

#
# ランキング
#
class Ranking
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :app_id, :game_id, :rank_type, :no, :rank, :user_id, :score
  
  validates_presence_of :app_id, :game_id, :rank_type, :no, :rank, :user_id, :score
  validates :app_id, :numericality => :only_integer
  validates :game_id, :numericality => :only_integer
  validates :rank_type, :numericality => :only_integer
  validates :no, :numericality => :only_integer
  validates :rank, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0}
  validates :user_id, :numericality => :only_integer
  validates :score, :numericality => {:greater_than_or_equal_to => 0}

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
  def table(version)
    "rank__#{self.app_id}_#{self.game_id}_#{self.rank_type}_#{version}_#{self.no}"
  end
    
  #
  # ランキングデータ追加
  #
  def save(version)
    Rails.cache.write(table(version), {:rank=>self.rank, :user_id=>self.user_id, :score=>self.score})
  end

  #
  # ランキング取得
  #
  def self.get_ranking(app_id, offset, limit)
    version = Version.current(app_id)
    rankings = {}

    limit.times do
      ranking_data = Rails.cache.read(table(version))

      if (ranking_data)
        # ユーザ情報をマージ
        userinfo = UserInfo.find(app_id, ranking_data.user_id)
        if (userinfo) 
          ranking_data.merge!({:userinfo=>userinfo})
        end
        rankings.merge!({offset => ranking_data})
      end
      offset += 1
    end

    rankings
  end
end