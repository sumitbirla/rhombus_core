require "digest/md5"
require "pundit"

class Admin::BaseController < ActionController::Base
  include Pundit
  force_ssl if Rails.env.production?

  protect_from_forgery
  layout 'admin/layouts/admin'
  before_action :require_login
  before_action :set_page_size

  helper_method :current_domain
  helper_method :current_user
  helper_method :systime
  helper_method :sysdate
  helper_method :sort_column, :sort_direction

  rescue_from Pundit::NotAuthorizedError do |e|
    @error = e
    render 'admin/shared/unauthorized'
  end

  rescue_from ActiveRecord::ActiveRecordError do |e|
    @error = e
    render 'admin/shared/database_error'
  end


  private


  def require_login
    # bypass login requrements if digest parameter is passed, works only when params[:id] is present
    if params[:digest] && params[:id]
      unless params[:digest] == Digest::MD5.hexdigest(params[:id].to_s + Cache.setting(Rails.configuration.domain_id, :system, 'Security Token'))
        return render text: "Invalid Url: #{request.url}", status: 403
      end
    else
      # remember me cookie
      if session[:user_id].nil? && !cookies.signed[:user_id].nil?
        session[:user_id] = cookies.signed[:user_id]
      end

      unless logged_in? && current_user.role.has_permission?('Login', 'allow')
        flash[:error] = "You must be logged in as admin to access this page"
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

  def set_page_size
    unless params[:per_page].blank?
      cookies[:per_page] = params[:per_page]
      @per_page = params[:per_page]
    else
      @per_page = cookies[:per_page] || 20
    end
  end

end