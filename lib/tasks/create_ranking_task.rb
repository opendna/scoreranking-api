#encoding: utf-8
include Cache

#
# ランキング生成バッチ
#　bundle exec rails runner "Tasks::CreateRankingTask.execute app_id:1"
class Tasks::CreateRankingTask

  def self.execute(params)
    app_id = params[:app_id]

    Rails.logger.debug "Tasks::CreateRankingTask start: app_id:#{app_id}"

    version = Ranking.current_version + 1
    Rails.logger.debug "version:#{version} ランキングデータを生成"

    create_rankings(app_id, version)

    increment_version(version)

    Rails.logger.debug "Tasks::CreateRankingTask end"
  end

  #
  # ランキングを生成する
  #
  def self.create_rankings(app_id, version)
    tablename_list = Score.get_tablename_list_array(app_id)

    tablename_list.each do |table_name|
      sql =<<-EOS
        select
          user_id,
          max(score) as score
        from #{table_name}
        where inserted_at >= DATE_ADD(NOW(), INTERVAL -3 MONTH)
        group by user_id
        order by score desc
        ;
      EOS
      Rails.logger.debug sql
      
      result = ActiveRecord::Base.connection.select(sql)
      
      no = 1
      rank = 1
      result.each do |rank|
        # ランキングを生成する

        # マイランキングを生成する

      end
    end
  end
  
  def self.increment_version(version)
    Cache.
  end
end