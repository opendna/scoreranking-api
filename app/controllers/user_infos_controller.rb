#encoding: utf-8

#
# ユーザ情報API
#
class UserInfosController < ApplicationController

  #
  # ユーザ情報登録／更新
  # PUT /user_info
  def save
    @userInfo = UserInfo.new({app_id: params[:app_id], user_id: params[:user_id], user_data: params[:user_data]})
    if @userInfo.valid?
      if @userInfo.save
        render :json => {'result'=>RESULT_OK} and return
      end
    end
    render :json => {'result'=>RESULT_NG}
  end
end
