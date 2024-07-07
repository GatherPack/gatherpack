class DateTimeInput < SimpleForm::Inputs::DateTimeInput
  def input(wrapper_options)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    
    @builder.datetime_field(attribute_name, merged_input_options)
  end
end