#encoding: utf-8

#
# ランキング生成バッチ
#　bundle exec rails runner "Tasks::CreateRankingTask.execute app_id:1"
#　bundle exec rails runner "Tasks::CreateRankingTask.reset_status app_id:1"
class Tasks::CreateRankingTask
  WORKING_STATUS_CACHE_KEY = "ranking_task_%d"

  def self.execute(params)
    app_id = params[:app_id]
    logd "Tasks::CreateRankingTask START, app_id:#{app_id}"

    Rails.cache.fetch(sprintf(WORKING_STATUS_CACHE_KEY, app_id)) do
      Rails.cache.write(sprintf(WORKING_STATUS_CACHE_KEY, app_id), true)

      next_version = Version.current(app_id) + 1
      create_rankings(app_id, next_version)
      Version.update(app_id, next_version)

      Rails.cache.delete(sprintf(WORKING_STATUS_CACHE_KEY, app_id))
      logd "Tasks::CreateRankingTask END, app_id:#{app_id}"
      return
    end
    
    loge "多重起動発生のため、バッチタスクを終了"
    loge "Tasks::CreateRankingTask END with duplicate execution error. app_id:#{app_id}"
  end

  #
  # ランキングを生成する
  #
  def self.create_rankings(app_id, version)
    logd "version:#{version} ランキング生成開始"

    tablename_list = Score.get_tablename_list(app_id)
    return if tablename_list.nil?

    logd "score_tables => #{tablename_list}"

    rank_type = 1
    tablename_list.each do |table|
      table_name = table['table_name']
      
      sql =<<-EOS
        select
          user_id,
          score,
          count(*) as total
        from (
          select
            user_id,
            max(score) as score
          from #{table_name}
          where inserted_at >= DATE_ADD(NOW(), INTERVAL -3 MONTH)
          group by user_id
        ) tmp
        order by score desc;
      EOS
      
      result = ActiveRecord::Base.connection.select(sql)

      game_id = Score.get_game_id(table_name)
      no = 1
      rank = 1
      prev_score = 0
      result.each do |rank_data|
        user_id = rank_data['user_id']
        score = rank_data['score']
        total = rank_data['total']

        # 同順位の判定
        rank = no if (score < prev_score)

        # ランキングを生成する
        @ranking = Ranking.new({:app_id=>app_id, :game_id=>game_id, :rank_type=>rank_type, :no=>no, :rank=>rank, :user_id=>user_id, :score=>score})
        if @ranking.valid?
          @ranking.save(version)
        end

        # マイランキングを生成する
        @myranking = Myranking.new({:app_id=>app_id, :user_id=>user_id, :game_id=>game_id, :rank=>rank, :score=>score, :total=>total})
        if @myranking.valid?
          @myranking.save(version)
        end
        
        no += 1
      end
    end
    logd "version:#{version} ランキング生成完了"
  end

  #
  # 実行中フラグをリセットする
  #
  def self.reset_status(params)
    app_id = params[:app_id]
    Rails.cache.delete(sprintf(WORKING_STATUS_CACHE_KEY, app_id))
  end

  #
  def self.logd(message)
    Rails.logger.debug message
  end

  #
  def self.loge(message)
    Rails.logger.error message
  end
end