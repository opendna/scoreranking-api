ScorerankingApi::Application.routes.draw do

  #
  # スコア送信API
  #
  match 'score/:app_id/:game_id/:user_id/:data', :to => 'scores#save', :via => :put
  match 'score', :to => 'scores#save', :via => :put
  
  match 'scores/:app_id/:datas', :to => 'scores#bulk_save', :via => :put
  match 'scores', :to => 'scores#bulk_save', :via => :put
  
  match 'score/:app_id/:game_id/:user_id', :to => 'scores#delete', :via => :delete
  match 'score', :to => 'scores#delete', :via => :delete
  
  match 'scores/:app_id/:datas', :to => 'scores#bulk_delete', :via => :delete
  match 'scores', :to => 'scores#bulk_delete', :via => :delete

  #
  # ユーザ情報API
  #
  match 'user_info/:app_id/:user_id/:data', :to => 'user_infos#save', :via => :put
  match 'user_info', :to => 'user_infos#save', :via => :put

  #
  # ランキングAPI
  #
  match 'ranking/:app_id/:game_id/:rank_type/:offset/:limit', :to => 'rankings#ranking'
  match 'ranking', :to => 'rankings#ranking'

  match 'my_ranking/:app_id/:user_id', :to => 'rankings#my_ranking'
  match 'my_ranking', :to => 'rankings#my_ranking'

  #
  # for debug
  #
  #get 'debug' => 'scores#index'
  #get 'debug' => 'user_infos#index'
  get 'debug' => 'rankings#index'

end
