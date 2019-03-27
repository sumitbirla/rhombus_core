module ImageHelper
  
  def cdn_image_url(pic, width, height, mode)
    
    if pic.blank?
      path = '/images/no-image.png'
    elsif pic.kind_of? String
      path = pic
    else
      path = pic.file_path
    end

    if path.starts_with?("http")
      return path
    else
      return Cache.setting(Rails.configuration.domain_id, :system, 'Static Files Url') + "/cache/#{width}x#{height}-#{mode}" + path
    end
  end
  
  def cdn_download_url(path)
    Cache.setting(Rails.configuration.domain_id, :system, 'Static Files Url') + path
  end
  
  
  def gravatar_url(email, size)
    gravatar = Digest::MD5::hexdigest(email).downcase
    url = "http://gravatar.com/avatar/#{gravatar}.png?s=#{size}"
  end
  
end