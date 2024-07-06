class FancyColorInput < SimpleForm::Inputs::ColorInput
  def input(wrapper_options)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    "<div class='form-control fancy-color-container row'><div class='col fancy-color-picker-col'>" +
      @builder.color_field(attribute_name, merged_input_options) +
      "</div><div class='col'>" + 
      @builder.input_field(attribute_name, merged_input_options) +
      "</div>" + 
    "</div>".html_safe
  end
end