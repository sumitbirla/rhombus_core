class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :logged_in?
  helper_method :current_user
  helper_method :sysdate
  helper_method :systime
  helper_method :sort_column, :sort_direction

  def not_found(msg = 'Not found')
    raise ActionController::RoutingError.new('Page not found!')
  end

  private

  def logged_in?
    !!current_user
  end

  def current_user
    return nil unless session[:user_id]
    @current_user ||= Cache.user(session[:user_id])
  end

  def sys_time_zone
    @timezone ||= Cache.setting(Rails.configuration.domain_id, :system, 'Time Zone')
  end

  def systime(time)
    time.in_time_zone(sys_time_zone).strftime("%Y-%b-%d &middot; %l:%M %p %Z").html_safe
  end

  def sysdate(time)
    time.in_time_zone(sys_time_zone).strftime("%Y-%b-%d").html_safe
  end
end