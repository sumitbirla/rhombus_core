class DatepickerInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    @builder.text_field(attribute_name, { class: "form-control date-field" })
  end
end