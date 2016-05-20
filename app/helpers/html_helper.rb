require 'phone'

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
  
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  end
  
  def formatted_phone(number)
    pn = Phoner::Phone.parse("+1" + number.sub("+", ""))
    pn.nil? ? number : pn.format(:us)
  end
  
end