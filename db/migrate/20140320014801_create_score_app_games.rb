class CreateScoreAppGames < ActiveRecord::Migration
  def change
    create_table :score_app_games do |t|
      t.integer :user_id
      t.integer :score

      t.timestamps
    end
  end
end
