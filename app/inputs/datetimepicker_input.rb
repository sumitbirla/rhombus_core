class DatetimepickerInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    value = object.send(attribute_name)
    value = value.strftime("%Y-%m-%d %I:%m %p") unless value.nil?
    @builder.text_field(attribute_name, { class: "form-control datetime-field", value: value })
  end
end