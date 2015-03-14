module ImageHelper
  def cdn_image_url(pic, width, height, mode)
    if pic.kind_of? String
      path = pic
    else
      path = pic.file_path
    end

    Cache.setting(Rails.configuration.domain_id, :system, 'Static Files Url') + "/cache/#{width}x#{height}-#{mode}" + path
  end
end