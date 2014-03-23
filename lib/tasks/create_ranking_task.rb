#encoding: utf-8

#
# ランキング生成バッチ
#　bundle exec rails runner "Tasks::CreateRankingTask.execute app_id:1,rank_type:1"
#　bundle exec rails runner "Tasks::CreateRankingTask.reset_status app_id:1"
class Tasks::CreateRankingTask
  WORKING_STATUS_CACHE_KEY = "ranking_task_%d"

  def self.execute(params)
    app_id = params[:app_id]
    rank_type = params[:rank_type]
    logd "Tasks::CreateRankingTask START, app_id:#{app_id} rank_type:#{rank_type}"

    if Rails.cache.read(sprintf(WORKING_STATUS_CACHE_KEY, app_id))
      loge "多重起動発生のため、バッチタスクを終了"
      loge "Tasks::CreateRankingTask END with duplicate execution error. app_id:#{app_id}"
      return
    end

    begin
      Rails.cache.write(sprintf(WORKING_STATUS_CACHE_KEY, app_id), true)

      next_version = Version.current(app_id) + 1
      create_rankings(app_id, rank_type, next_version)
      Version.update(app_id, next_version)
    # rescue => e
    #   loge "Tasks::CreateRankingTask END with Exception. app_id:#{app_id}, Exception is:"
    #   loge e
    # else
      logd "Tasks::CreateRankingTask END, app_id:#{app_id}"
    ensure
      Rails.cache.delete(sprintf(WORKING_STATUS_CACHE_KEY, app_id))
    end
  end

  #
  # ランキングを生成する
  #
  def self.create_rankings(app_id, rank_type, version)
    logd "version:#{version} ランキング生成開始"

    tablename_list = Score.get_tablename_list(app_id)
    return if tablename_list.nil?

    logd "score_tables => #{tablename_list}"

    where = condition(app_id, rank_type)
    tablename_list.each do |table|
      table_name = table['table_name']
      
      sql =<<-EOS
        select
          user_id,
          score
        from (
          select
            user_id,
            max(score) as score
          from #{table_name}
          where #{where}
          group by user_id
        ) tmp
        order by score desc;
      EOS
      
      result = ActiveRecord::Base.connection.select(sql)
      total = result.count

      game_id = Score.get_game_id(table_name)
      no = 1
      rank = 1
      prev_score = 0
      result.each do |rank_data|
        user_id = rank_data['user_id']
        score = rank_data['score']

        # 同順位の判定
        rank = no if (score < prev_score)

        # ランキングを生成する
        Ranking.insert(version, app_id, game_id, rank_type, no, rank, user_id, score)
        # マイランキングを生成する
        Myranking.insert(version, app_id, user_id, game_id, rank, score, total)
        
        no += 1
      end
    end
    logd "version:#{version} ランキング生成完了"
  end

  #
  # ランキング対象データ検索条件
  #
  def self.condition(app_id, rank_type)
    # ランキングタイプを設定ファイルからロード
    send("condition_by_quarter")
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

  #
  # ランキングタイプ：四半期
  #
  def self.condition_by_quarter
    # 四半期ごとの期間を指定する
    # 1月〜3月｜4月〜6月｜7月〜9月｜10月〜12月
    q = (Time.new.month/3.0).ceil
    year = Time.new.year

    case q
    when 1
      return "inserted_at between '#{year}-01-01 0:00:00' and '#{year}-03-31 23:59:59'"
    when 2
      return "inserted_at between '#{year}-04-01 0:00:00' and '#{year}-06-30 23:59:59'"
    when 3
      return "inserted_at between '#{year}-07-01 0:00:00' and '#{year}-09-30 23:59:59'"
    when 4
      return "inserted_at between '#{year}-10-01 0:00:00' and '#{year}-12-31 23:59:59'"
    else
      "1=1"
    end
  end
end