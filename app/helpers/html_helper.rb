module HtmlHelper
  
  def tick(obj)
    "&#10004;".html_safe if obj
  end
  
  def duration(h, val)
    return "0:00" if h.nil? || h[val].nil?
    Time.at(h[val]).utc.strftime("%k:%M:%S")
  end

  def duration_int(h, val)
    return 0 if h.nil? || h[val].nil?
    h[val].to_f
  end
  
  def time_ago(time, append = '')
    return time_ago_in_words(time).gsub(/about|less than|almost|over/, '').strip << append
  end
  
end