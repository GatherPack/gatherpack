# frozen_string_literal: true

class ComboboxInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    template.combobox_tag(
      "#{object_name}[#{attribute_name}]",
      object.send(attribute_name)&.to_s,
      url: template.combo_search_path(scope: @options[:scope]),
      render_in: { partial: "search/result" },
      class: "form-select"
    )
  end
end
