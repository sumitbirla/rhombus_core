class ApplicationController < ActionController::Base
  protect_from_forgery
  
  #before_filter :prepare_for_mobile
  helper_method :logged_in?
  helper_method :current_user
  helper_method :sysdate
  helper_method :systime
  helper_method :mobile_device?
  
  
  def not_found(msg = 'Not found')
    return render text: msg, status: 404
  end
  

  private
  
  def logged_in?
    session[:user_id]
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
  
  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end
  end
  
  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
    request.format = :mobile if mobile_device?
  end

end