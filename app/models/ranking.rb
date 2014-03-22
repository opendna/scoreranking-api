#encoding: utf-8

#
# ランキング
#
class Ranking

    
  RANKING_CACHE_KEY_FORMAT = "rank_%d_%d_%d_%d_%d" # rank_[app_id]_[game_id]_[rank_type]_[version]_[no]
  DATA_DELEMITER = "|"

  #
  # ランキングデータ追加
  #
  def self.insert_ranking(app_id, game_id, rank_type, version, no, rank, user_id, score)
    key = sprintf(RANKING_CACHE_KEY_FORMAT, app_id, game_id, rank_type, version, no);
    Rails.logger.debug "insert_ranking:#{key}"
    Rails.cache.write(key, "#{rank},#{user_id},#{score}")
  end

  #
  # ランキング取得
  #
  def self.get_ranking(condition)
    rankings = {}
    version = Version.current(condition.app_id)

    loop_count = condition.limit.to_i
    number = condition.offset.to_i

    loop_count.times do
      key = sprintf(RANKING_CACHE_KEY_FORMAT, condition.app_id, condition.game_id, condition.rank_type, version, number);
      ranking_data = Rails.cache.read(key)

      if (ranking_data)
        # ユーザ情報をマージ
        user_id = ranking_data.split(',')[1].to_i
        userinfo = UserInfo.find(condition.app_id, user_id)
        if (userinfo) 
          ranking_data = "#{ranking_data}#{DATA_DELEMITER}#{userinfo}"
        end
        rankings.merge!({number => ranking_data})
      end
      number += 1
    end
    rankings
  end
end