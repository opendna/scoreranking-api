#encoding: utf-8

#
# ランキング検索条件
#
class RankingParameter < NonPersistedModel

  attr_accessor :app_id, :game_id, :rank_type, :offset, :limit
  
  validates_presence_of :app_id, :game_id, :rank_type, :offset, :limit
  validates :app_id, :numericality => :only_integer
  validates :rank_type, :numericality => :only_integer
  validates :offset, :numericality => {:only_integer => true, :greater_than => 0}
  validates :limit, :numericality => {:only_integer => true, :greater_than => 0, :less_than_or_equal_to => 100}
  
end