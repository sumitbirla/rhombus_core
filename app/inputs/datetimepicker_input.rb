class DatetimepickerInput < SimpleForm::Inputs::Base
  def input
    value = object.send(attribute_name)
    value = value.strftime("%Y-%m-%d %l:%m %p") unless value.nil?
    @builder.text_field(attribute_name, { class: "form-control datetime-field", value: value })
  end
end