crumb :shortcuts do
  link "Shortcuts", shortcuts_path
end

crumb :shortcut do |shortcut|
  link shortcut.new_record? ? "New shortcut" : shortcut.identifier_name, shortcut
  parent :shortcuts
end
