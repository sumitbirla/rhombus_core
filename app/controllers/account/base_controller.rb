class Account::BaseController < ApplicationController
  force_ssl  if Rails.env.production?
  
  before_action :require_login
  helper_method :current_user

	layout 'account'
	
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