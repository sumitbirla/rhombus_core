class Account::BaseController < ApplicationController
  before_filter :require_login
  
  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in to access this page"
      redirect_to login_path
    end
  end
  
  def logged_in?
    !!current_user
  end
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

end