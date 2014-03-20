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
  # for debug
  #
  get 'score' => 'scores#index'
  get 'user_info' => 'user_infos#index'

end
