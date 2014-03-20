#encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery

  include Cache

  #
  # レスポンスコード
  #
  RESULT_OK = 0
  RESULT_NG = 9
end
