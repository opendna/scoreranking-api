#encoding: utf-8

#
# マイランキング
#
class Myranking

  MYRANKING_CACHE_KEY_FORMAT = "myrank_%d_%d_%d" # myrank_[app_id]_[version]_[user_id]
  DATA_DELEMITER = "|"

  #
  # マイランキングデータ追加
  #
  def self.insert_myranking(app_id, version, user_id, game_id, rank, score)
    key = sprintf(MYRANKING_CACHE_KEY_FORMAT, app_id, version, user_id);
    Rails.logger.debug "insert_myranking:#{key}"
    
    value = Rails.cache.fetch(key) do
      Rails.cache.write(key, "#{value}#{game_id},#{rank},#{score}#{DATA_DELEMITER}")
    end
    
  end

  #
  # マイランキングデータ取得
  #
  def self.get_ranking(condition)
    version = Version.current(condition.app_id)
        
    key = sprintf(MYRANKING_CACHE_KEY_FORMAT, condition.app_id, version, condition.user_id);
    return Rails.cache.read(key)
  end
end