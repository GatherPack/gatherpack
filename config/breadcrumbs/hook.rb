crumb :hooks do
  link "Hooks", hooks_path
end

crumb :hook do |hook|
  link hook.identifier_name, hook
  parent :hooks
end