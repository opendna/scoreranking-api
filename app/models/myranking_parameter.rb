#encoding: utf-8

#
# マイランキング検索条件
#
class MyrankingParameter < NonPersistedModel

  attr_accessor :app_id, :user_id
  
  validates_presence_of :app_id, :user_id
  validates :app_id, :numericality => :only_integer
  validates :user_id, :numericality => :only_integer
end