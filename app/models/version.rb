#encoding: utf-8

#
# バージョン管理
#
class Version

  CURRENT_VERSION_CACHE_KEY = "current_version_%d"

  def self.db_table
    return "ranking_version"
  end

  def self.create_table_if_need(table_name)
    Rails.cache.fetch("exists_version_table__" + table_name) do
      sql =<<-EOS
        create table #{table_name} if not exists(
          app_id integer not null,
          current_version default 0
        );
      EOS
    end
  end

  #
  # ランキングバージョンを取得
  #
  def self.current(app_id)
    current_version = Rails.cache.fetch(sprintf(CURRENT_VERSION_CACHE_KEY, app_id)) do
      # バージョンがない場合はDBから取得
      create_table_if_need(db_table)

      sql =<<-EOS
        select current_version from #{db_table} where app_id = #{app_id};
      EOS
      result = ActiveRecord::Base.connection.select sql
      result[:current_version]
    end
  end
  
  #
  # ランキングバージョンを更新
  #
  def self.update(app_id, version)
    Rails.cache.write(sprintf(CURRENT_VERSION_CACHE_KEY, app_id), version)
    
    sql =<<-EOS
      update #{db_table} set current_version = #{version} where app_id = #{app_id};
    EOS
    result = ActiveRecord::Base.connection.execute sql
  end
end