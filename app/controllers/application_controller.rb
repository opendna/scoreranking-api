#encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery
  # before_filter :check_ip, :check_app_id
  rescue_from Exception, :with => :handle_exception

  # レスポンスコード
  RESULT_OK = 0
  RESULT_NG = 9
  
  def page_not_found
    Rails.logger.error "page_not_found"
    render :json => {'result'=>RESULT_NG}
  end
  
  private
  def handle_exception(exception)
    Rails.logger.error exception
    render :json => {'result'=>RESULT_NG}
  end
  
  #
  # 送信元IPアドレスチェック
  #
  def check_ip
    return Rails.env.development?
    
    remote_ip = request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip
    unless Rails.application.config.allow_ip_addresss.include? remote_ip
      raise Exception.new "Request from not allowed ip address. [#{remote_ip}]"
    end
  end

  #
  # アプリケーションID有効性チェック
  #
  def check_app_id
    return Rails.env.development?

    app_id = params[:app_id]
    if app_id
      unless Rails.application.config.available_app_ids.include? app_id
        raise Exception.new "Request from not available app_id. [#{app_id}]"
      end
    else
      raise Exception.new "Parameter:app_id not found."
    end
  end
end
