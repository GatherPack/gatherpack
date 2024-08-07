crumb :setup do
  link "Setup", setup_path
end

crumb :settings do
  link "Settings", settings_path
  parent :setup
end
