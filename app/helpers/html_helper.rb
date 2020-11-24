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
    link_to title, params.permit!.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  end

  def formatted_phone(number)
    number_to_phone(number)
  end

  def tab_count(name, count, alert = false)
    return name if count == 0
    str = "#{name} (#{number_with_delimiter count})"
    str = "<i class='fa fa-exclamation-circle text-danger'></i> " + str if alert
    str.html_safe
  end

  def link_to_user_or_affiliate(obj, q = nil)
    if obj.user
      return link_to(obj.user.name, admin_system_user_path(obj.user_id, q: q))
    elsif obj.affiliate
      return link_to(obj.affiliate.name, admin_system_affiliate_path(obj.affiliate_id, q: q))
    else
      return "<span class='light'>- system -</span>".html_safe
    end
  end

  def tel_to(phone_number)
    phone_number = number_to_phone(phone_number)
    link_to phone_number, "tel:#{phone_number}"
  end

  # print a table row.  opts include :label, :default
  def obj_property(obj, var_name, opts = {})
    val = obj.send(var_name)
    return "" if val.blank? && opts[:default].nil?

    label = opts[:label] || var_name.to_s.titlecase
    val = yield(val) if block_given?

    # handle special data types
    case val.class.name
    when "Time"
      val = systime(val)
    when "Date"
      val = sysdate(val)
    when "DateTime"
      val = systime(val)
    when "BigDecimal"
      val = number_to_currency(val)
    when "ActsAsTaggableOn::TagList"
      val = tag_list(obj)
    end

    # auto link email, web and phone values
    if var_name == :email
      val = mail_to(val)
    elsif var_name == :phone
      val = link_to("tel:#{val}") { "<i class='fa fa-phone'></i> #{val}".html_safe }
    elsif var_name == :website
      val = "http://#{val}" if !val.start_with?('http')
      val = link_to(val, val)
    end

    str = <<-EOF
    <tr>
			<td class="key">#{label}</td>
			<td>#{val || opts[:default]}</td>
		</tr>  
    EOF

    str.html_safe
  end

  # print a list of tags  (object.tag_list)
  def tag_list(obj)
    str = ""

    obj.tag_list.each do |tag|
      str += "<span class='label label-info'>#{tag}</span> &nbsp;"
    end

    str.html_safe
  end

  def ckfinder_input(obj, attr_name, options = {})
    obj_name = obj.class.name.underscore
    element_id = obj_name + "_" + attr_name
    value = obj.send(attr_name)

    preview = ""
    unless (options[:preview] == false) || value.blank?
      preview = "<img src='#{cdn_image_url(value, 200, 120, 0)}'/><br>"
    end

    str = <<-EOF
      <div class="form-group #{element_id}">
    	  <label class="string optional control-label col-sm-3" for="#{element_id}">#{attr_name}</label>
        <div class="col-md-9">
          #{preview}
    	    <input type="text" class="form-control" style="width: 50%; display: inline;" name="#{obj_name}[#{attr_name}]" id="#{element_id}" value="#{value}" />
          <input type="button" value="Browse Server" class="btn btn-default" onclick="filePopup('#{element_id}')">
        </div>
      </div>
    EOF

    str.html_safe
  end

  def ckeditor_input(obj, attr_name, options = {})
    obj_name = obj.class.name.underscore
    element_id = obj_name + "_" + attr_name
    value = obj.send(attr_name)

    str = <<-EOF
      <div class="form-group #{element_id}">
    	  <label class="string optional control-label col-sm-3" for="#{element_id}">#{attr_name.titlecase}</label>
        <div class="col-md-9">
    	    <textarea class="form-control" name="#{obj_name}[#{attr_name}]" id="#{element_id}">#{value}</textarea>
        </div>
      </div>
    
      <script>
      ClassicEditor
      	.create( document.querySelector( '##{element_id}' ), {
      		ckfinder: {
      			uploadUrl: '/ckfinder/core/connector/php/connector.php?command=QuickUpload&type=Images&responseType=json',
      		},
      		toolbar: [ 'heading', '|', 'bold', 'italic', 'link', 'ckfinder', '|', 'bulletedList', 'numberedList', 'blockQuote', 'insertTable', 'undo', 'redo' ]
      	} )
      	.catch( error => {
      		console.error( error );
      	} );
        </script>
    EOF

    str.html_safe
  end

  def ckeditor_input_field(obj, attr_name, options = {})
    obj_name = obj.class.name.underscore
    element_id = obj_name + "_" + attr_name
    value = obj.send(attr_name)

    str = <<-EOF
			<textarea class="form-control" name="#{obj_name}[#{attr_name}]" id="#{element_id}">#{value}</textarea>

      <script>
      ClassicEditor
      	.create( document.querySelector( '##{element_id}' ), {
      		ckfinder: {
      			uploadUrl: '/ckfinder/core/connector/php/connector.php?command=QuickUpload&type=Images&responseType=json',
      		},
      		toolbar: [ 'heading', '|', 'bold', 'italic', 'link', 'ckfinder', '|', 'bulletedList', 'numberedList', 'blockQuote', 'insertTable', 'undo', 'redo' ]
      	} )
      	.catch( error => {
      		console.error( error );
      	} );
        </script>
    EOF

    str.html_safe
  end

  def cdn_url(path)
    @base_path ||= Cache.setting(Rails.configuration.domain_id, :system, 'Static Files Url')
    @base_path + path
  end

end