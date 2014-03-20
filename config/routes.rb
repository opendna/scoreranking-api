ScorerankingApi::Application.routes.draw do

  # スコア送信API
  resource :score_app_game

  # ユーザ情報API
  resource :user_info

  get 'debug' => 'user_infos#index'

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'
end
