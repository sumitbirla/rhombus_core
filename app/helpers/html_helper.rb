module HtmlHelper
  
  def tick(obj)
    if obj
      str = "&#10004;"
    else
      str = "<span class='light'> - </span>"
    end
    str.html_safe
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
    number_to_phone(number)
  end
  
  def tab_count(name, count)
    return name if count == 0
    "#{name} (#{number_with_delimiter count})"
  end
  
  def obj_property(obj, var_name, opts = {})
    val = obj.send(var_name)
    return "" if val.blank?
    
    label = opts[:label] || var_name.to_s.titlecase
    val = yield(val) if block_given?
    
    case val.class.name
    when "Time"
      val = systime(val)
    when "Date"
      val = sysdate(val)
    when "DateTime"
      val = systime(val)
    when "BigDecimal"
      val = number_to_currency(val)
    end
    
		str = <<-EOF
    <tr>
			<td class="key">#{label}</td>
			<td>#{val}</td>
		</tr>  
    EOF
    
    str.html_safe
  end
  
end