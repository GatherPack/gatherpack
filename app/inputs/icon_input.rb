class IconInput < SimpleForm::Inputs::TextInput
  def input(wrapper_options)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options);

    "<div class='icon-select-wrapper form-control'><div class='icon-input-wrapper'><i class='fa-solid fa-circle-question main-icon'></i>" + 
    @builder.text_field(attribute_name, merged_input_options) +
    "</div><div class='icon-select-list' style='display: none'></div></div>".html_safe
  end
end