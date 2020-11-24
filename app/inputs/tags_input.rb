class TagsInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    @builder.text_field(attribute_name, {"data-role" => "tagsinput", value: object.tag_list.join(",")})
  end
end