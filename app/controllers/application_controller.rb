#encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery
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
end
