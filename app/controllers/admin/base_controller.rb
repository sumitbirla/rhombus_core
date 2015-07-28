require "xmlrpc/client"
require "digest/md5"

class Admin::BaseController < ActionController::Base
  force_ssl  if Rails.env.production?

  protect_from_forgery
  layout 'admin/layouts/admin'
  before_filter :require_login
  
  helper_method :current_domain
  helper_method :current_user
  helper_method :systime
  helper_method :sysdate

  private
  
  def require_login
    # bypass login requrements if digest parameter is passed, works only when params[:id] is present
    if params[:digest] && params[:id]
      unless params[:digest] == Digest::MD5.hexdigest(params[:id].to_s + Cache.setting(Rails.configuration.domain_id, :system, 'Security Token')) 
        return render text: "Invalid Url: #{request.url}", status: 403
      end
    else
      unless current_user && current_user.role.super_user
        flash[:error] = "You must be logged in to access this page"
        redirect_to admin_login_path(redirect: request.fullpath)
      end
    end
  end
  
  def logged_in?
    !!current_user
  end
  
  def current_user
    return nil unless session[:user_id]
    @current_user ||= Cache.user(session[:user_id])
  end
  
  def current_domain
    Cache.domains.find { |x| x.id == cookies[:domain_id].to_i }
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