# frozen_string_literal: true

class SearchingComboboxInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    raise ArgumentError, "SearchingComboboxInput requires a :scope option" unless @options[:scope].present?

    input_html_options = merge_wrapper_options(input_html_options || {}, wrapper_options || {})
    input_html_options[:value] = object.send(attribute_name)

    @builder.combobox(attribute_name, template.combo_search_path(scope: @options[:scope], attribute: attribute_name), **input_html_options)
  end
end
