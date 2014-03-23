#encoding: utf-8

#
# マイランキング
#
class Myranking

  #
  # テーブル名
  #
  def self.table(app_id, version, user_id)
    "myrank__#{app_id}_#{version}_#{user_id}"
  end
  
  #
  # マイランキングデータ追加
  #
  def self.insert(version, app_id, user_id, game_id, rank, score, total)
    
    data = Rails.cache.fetch(table(app_id, version, user_id)) do
      [{:game_id=>game_id, :score=>score, :rank=>rank, :total=>total}]
      return
    end
    
    data.push({:game_id=>game_id, :score=>score, :rank=>rank, :total=>total})
    Rails.cache.write(table(app_id, version, user_id), data)
  end

  #
  # マイランキングデータ取得
  #
  def self.get_ranking(condition)
    version = Version.current(condition.app_id)
    Rails.cache.read(table(condition.app_id, version, condition.user_id))
  end
end