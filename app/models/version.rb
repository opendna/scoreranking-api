#encoding: utf-8

#
# バージョン管理
#
class Version

  CURRENT_VERSION_CACHE_KEY = "current_version_%d"

  #
  # ランキングバージョンを取得
  #
  def self.current(app_id)
    current_version = Rails.cache.fetch(sprintf(CURRENT_VERSION_CACHE_KEY, app_id)) do
      # バージョンがない場合は初期化 version=0
      current_version = 0
    end
  end
  
  #
  # ランキングバージョンを更新
  #
  def self.update_version(app_id, version)
    Rails.cache.write(sprintf(CURRENT_VERSION_CACHE_KEY, app_id), version)
  end
end