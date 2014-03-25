#encoding: utf-8

#
# バージョン管理
#
class Version

  def self.db_table
    "ranking_version"
  end
  
  def self.cache_table(app_id)
    "current_version_#{app_id}"
  end

  def self.create_table_if_need
    Rails.cache.fetch("exists_version_table__" + db_table) do
      sql =<<-EOS
        create table if not exists #{db_table} (
          app_id integer not null,
          current_version integer default 0
        );
      EOS
      ActiveRecord::Base.connection.execute sql
      true
    end
  end

  #
  # ランキングバージョンを取得
  #
  def self.current(app_id)
    current_version = Rails.cache.fetch(cache_table(app_id)) do
      # バージョンがない場合はDBから取得
      create_table_if_need

      sql =<<-EOS
        select current_version from #{db_table} where app_id = #{app_id};
      EOS
      result = ActiveRecord::Base.connection.select_one sql
      if !(result.nil? || result.empty?)
        current_version = result['current_version']
      else
        current_version = 0
        sql =<<-EOS
          insert into #{db_table}(app_id, current_version) values(#{app_id}, #{current_version});
        EOS
        ActiveRecord::Base.connection.execute sql
      end
      current_version
    end
    current_version
  end
  
  #
  # ランキングバージョンを更新
  #
  def self.update(app_id, version)
    Rails.cache.write(cache_table(app_id), version)
    
    sql =<<-EOS
      update #{db_table} set current_version = #{version} where app_id = #{app_id};
    EOS
    ActiveRecord::Base.connection.execute sql
  end
end