class DatepickerInput < SimpleForm::Inputs::Base
  def input
    @builder.text_field(attribute_name, { class: "form-control date-field" })
  end
end