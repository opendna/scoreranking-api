#encoding: utf-8
class ScoreAppGame < ActiveRecord::Base
  attr_accessible :user_id, :score
end
