#encoding: utf-8
include Cache

#
# ランキング生成バッチ
#　bundle exec rails runner "Tasks::CreateRankingTask.execute app_id:1"
#　bundle exec rails runner "Tasks::CreateRankingTask.reset_status"
class Tasks::CreateRankingTask
  WORKING_STATUS_CACHE_KEY = "ranking_task"

  def self.execute(params)
    return if duplicate_execution

    start_task params

    app_id = params[:app_id]
    next_version = Ranking.current_version.to_i + 1
    create_rankings(app_id, next_version)
    
    Ranking.update_version

    end_task
  end
  
  #
  # ランキングを生成する
  #
  def self.create_rankings(app_id, version)
    logd "version:#{version} ランキング生成開始"

    tablename_list = Score.get_tablename_list_array(app_id)
    return if tablename_list.nil?

    logd "score_tables => #{tablename_list}"

    rank_type = 1
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
      
      result = ActiveRecord::Base.connection.select(sql)

      game_id = table_name.split('_')[1].to_i
      no = 1
      rank = 1
      score = 0
      result.each do |rank_data|
        # 上位とスコアを比較し、同順位とするか判定
        if (1 < no)
          if (rank_data['score'] < score)
            rank = no
          end
        end

        user_id = rank_data['user_id']
        score = rank_data['score']

        # ランキングを生成する
        Ranking.insert_ranking(app_id, game_id, rank_type, version, no, rank, user_id, score)

        # マイランキングを生成する
        Ranking.insert_myranking(app_id, version, user_id, game_id, rank, score)
        
        no += 1
      end
    end

    logd "version:#{version} ランキング生成完了"
  end

  #
  # タスク実行開始
  #
  def self.start_task(params)
    logd "Tasks::CreateRankingTask start, params:#{params}"
    Cache.set(WORKING_STATUS_CACHE_KEY, "working!")
  end
  
  #
  # タスク実行終了
  #
  def self.end_task
    logd "Tasks::CreateRankingTask END"
    Cache.delete(WORKING_STATUS_CACHE_KEY)
  end

  #
  # 起動チェック
  #
  def self.duplicate_execution
    if Cache.get(WORKING_STATUS_CACHE_KEY)
      loge "多重起動発生のため、バッチタスクを終了"
      loge "Tasks::CreateRankingTask END with duplicate execution error."
      return true
    end
    return false
  end

  #
  # 実行中フラグをリセットする
  #
  def self.reset_status
    Cache.delete(WORKING_STATUS_CACHE_KEY)
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