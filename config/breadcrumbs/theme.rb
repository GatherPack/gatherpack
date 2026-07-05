crumb :theme do
  link "Theme", theme_path
  parent :setup
end

crumb :edit_theme do
  link "Edit Theme", edit_theme_path
  parent :theme
end
