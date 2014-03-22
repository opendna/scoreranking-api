#encoding: utf-8

#
# マイランキング検索条件
#
class MyrankingParameter
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :app_id, :user_id
  
  validates_presence_of :app_id, :user_id
  validates :app_id, :numericality => :only_integer
  validates :user_id, :numericality => :only_integer

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  def persisted?
    false
  end
end