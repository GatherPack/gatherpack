# frozen_string_literal: true

class CurrencyInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    merged_input_options[:type] = 'number'
    merged_input_options[:step] = '0.01'
    merged_input_options[:min] = '0'
    merged_input_options[:inputmode] = 'decimal'
    merged_input_options[:class] ||= []
    merged_input_options[:class] << 'form-control'
    merged_input_options[:value] = formatted_value(object, attribute_name)

    currency_symbol = options[:currency] || '$'

    template.content_tag(:div, class: 'input-group') do
      template.concat(
        template.content_tag(:span, currency_symbol, class: 'input-group-text fw-bold')
      )
      template.concat @builder.text_field(attribute_name, merged_input_options)
    end
  end

  private

  def formatted_value(object, attribute_name)
    value = object.try(attribute_name)
    return unless value
    '%.2f' % value
  end
end
