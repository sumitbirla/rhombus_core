require "xmlrpc/client"
require "digest/md5"

class Admin::BaseController < ActionController::Base
  force_ssl  if Rails.env.production?

  protect_from_forgery
  layout 'admin/layouts/admin'
  before_filter :require_login
  
  helper_method :current_domain
  helper_method :current_user
  helper_method :tick
  helper_method :cdn_image_url
  helper_method :systime
  helper_method :sysdate
  helper_method :order_status
  helper_method :po_status
  helper_method :poi_status
  helper_method :readable_file_size
  helper_method :sortable
  helper_method :duration
  helper_method :duration_int
  helper_method :agent_desc
  helper_method :rpc_exec

  private
  
  def require_login
    # bypass login requrements if digest parameter is passed
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
  
  def tick(obj)
    "&#10004;".html_safe if obj
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
  
  def order_status(order, css = '')
    css_class = css + ' '
    
    if ['shipped', 'completed'].include?(order.status)
      css_class += 'label-success'
    elsif ['refunded', 'cancelled'].include?(order.status)
      css_class += 'label-warning'
    elsif order.status == 'backordered'
      css_class += 'label-important'
    else
      css_class += 'label-info'
    end
    
    "<span class='label #{css_class}'>#{order.status}</span>".html_safe
  end
  
  def po_status(po, css = '')
    css_class = css + ' '
    
    if po.status == 'open'
      css_class += 'label-default'
    elsif ['late', 'cancelled'].include?(po.status)
      css_class += 'label-warning'
    elsif po.status == 'received'
      css_class += 'label-success'
    elsif po.status == 'partially_received'
      css_class += 'label-important'
    else
      css_class += 'label-default'
    end
    
    "<span class='label #{css_class}'>#{po.status}</span>".html_safe
  end
  
  def poi_status(poi, css = '')
    css_class = css + ' '
    
    if poi.status == 'partial'
      css_class += 'label-important'
    elsif poi.status == 'received'
      css_class += 'label-success'
    else
      css_class += 'label-warning'
    end
    
    "<span class='label #{css_class}'>#{poi.status}</span>".html_safe
  end
  
  def cdn_image_url(pic, width, height, mode)
    
    if pic.kind_of? String
      path = pic
    else
      path = pic.file_path
    end
    
    Cache.setting(Rails.configuration.domain_id, :system, 'Static Files Url') + "/cache/#{width}x#{height}-#{mode}" + path
  end
  
  
  # Return the file size with a readable style.
  KILO_SIZE = 1024
  MEGA_SIZE = 1024 * 1024
  GIGA_SIZE = 1024 * 1024 * 1024
  
  def readable_file_size(size, precision)
    case
      when size == 1 ; "1 Byte"
      when size < KILO_SIZE ; "%d Bytes" % size
      when size < MEGA_SIZE ; "%d KB" % (size / KILO_SIZE)
      when size < GIGA_SIZE ; "%.#{precision}f MB" % (size / MEGA_SIZE)
      else "%.#{precision}f GB" % (size / GIGA_SIZE)
    end
  end


  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"

    h = {:sort => column, :direction => direction}
    params.each do |k,v|
      h[k] = v unless v.empty? || ['direction', 'sort'].include?(k)
    end

    link_to title, h, {:class => css_class}
  end

  def duration(h, val)
    return "0:00" if h.nil? || h[val].nil?
    Time.at(h[val]).utc.strftime("%k:%M:%S")
  end

  def duration_int(h, val)
    return 0 if h.nil? || h[val].nil?
    h[val].to_f
  end

  def agent_status_desc(code)
    statuses = Rails.cache.fetch('fs_agent_statuses') do
      FsAgentStatus.all
    end

    statuses.find { |x| x.code == code }
  end

  def rpc_exec(cmd, params)
    fs_host = Cache.setting(:pbx, 'FreeSWITCH Host')
    @@client ||= XMLRPC::Client.new(fs_host, "/RPC2", 8080, nil, nil, "freeswitch", "works", nil, nil)
    @@client.call("freeswitch.api", cmd, params)
  end
  
end