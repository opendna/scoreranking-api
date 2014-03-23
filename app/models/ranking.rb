#encoding: utf-8

#
# ランキング
#
class Ranking

  #
  # テーブル名
  #
  def self.table(app_id, game_id, rank_type, version, no)
    "rank__#{app_id}_#{game_id}_#{rank_type}_#{version}_#{no}"
  end
    
  #
  # ランキングデータ追加
  #
  def self.insert(version, app_id, game_id, rank_type, no, rank, user_id, score)
    Rails.cache.write(table(app_id, game_id, rank_type, version, no), {:rank=>self.rank, :user_id=>self.user_id, :score=>self.score})
  end

  #
  # ランキング取得
  #
  def self.get_ranking(condition)
    version = Version.current(condition.app_id)
    rankings = {}
    
    limit = condition.limit.to_i
    offset = condition.offset.to_i

    limit.times do
      ranking_data = Rails.cache.read(table(condition.app_id, condition.game_id, condition.rank_type, version, offset))

      if (ranking_data)
        # ユーザ情報をマージ
        userinfo = UserInfo.find(condition.app_id, ranking_data[:user_id])
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