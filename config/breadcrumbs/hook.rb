crumb :hooks do
  link "Hooks", hooks_path
end

crumb :hook do |hook|
  link hook.new_record? ? "New hook" : hook.identifier_name, hook
  parent :hooks
end
