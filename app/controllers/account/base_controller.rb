class Account::BaseController < ApplicationController
  before_action :require_login
  before_action :set_page_size
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

  def set_page_size
    unless params[:per_page].blank?
      cookies[:per_page] = params[:per_page]
      @per_page = params[:per_page]
    else
      @per_page = cookies[:per_page] || 20
    end
  end

end