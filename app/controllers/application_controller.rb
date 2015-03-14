class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  helper_method :sysdate
  helper_method :systime

  private
  
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
    @current_user ||= Cache.user(session[:user_id])
  end

  def sys_time_zone
    @timezone ||= Cache.setting(Rails.configuration.domain_id, :system, 'Time Zone')
  end

  def systime(time)
    time.in_time_zone(sys_time_zone).strftime("%m/%d/%Y &nbsp;%I:%M %P").html_safe
  end

  def sysdate(time)
    time.in_time_zone(sys_time_zone).strftime("%m/%d/%Y").html_safe
  end

  
end