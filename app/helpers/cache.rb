module Cache

  def self.setting(section, key) 
    Rails.cache.fetch("setting:#{section}:#{key}") do 
      s = Setting.find_by(section: section, key: key)
      s.value unless s.nil?
    end
  end

end