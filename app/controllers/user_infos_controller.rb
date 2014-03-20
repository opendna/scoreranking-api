#encoding: utf-8

#
# ユーザ情報API
#
class UserInfosController < ApplicationController

  #
  # ユーザ情報登録／更新
  # PUT /user_info (app_id,user_id,data)
  def save
    app_id = params[:app_id]
    user_id = params[:user_id]
    data = params[:data]

    UserInfo.create_table(app_id)
    UserInfo.save(app_id, user_id, data)
  
    render :json => {'result'=>RESULT_OK}
  end
end
