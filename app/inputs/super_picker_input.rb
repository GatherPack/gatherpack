class SuperPickerInput < SimpleForm::Inputs::TextInput
  def class_name()
    "super-picker"
  end

  def wrapper_prefix()
    ""
  end

  def input(wrapper_options)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options);

    "<div class='#{class_name}-select-wrapper form-control'><div class='#{class_name}-input-wrapper'>" + 
    wrapper_prefix + 
    @builder.text_field(attribute_name, merged_input_options) +
    "</div><div class='#{class_name}-select-list' style='display: none'></div></div>".html_safe
  end
end