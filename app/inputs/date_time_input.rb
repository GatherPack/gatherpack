class DateTimeInput < SimpleForm::Inputs::DateTimeInput
  def input(wrapper_options)
    wrapper_options[:class] = ["form-select"]
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    
    @builder.date_field(attribute_name, merged_input_options)
  end
end