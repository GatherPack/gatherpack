module SearchHelper
  def combobox_option(record)
    "#{i record.identifier_icon} #{record.identifier_name}".html_safe
  end
end
