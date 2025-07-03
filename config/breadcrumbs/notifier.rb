crumb :notifiers do
  link "Notifiers", notifiers_path
end

crumb :notifier do |notifier|
  link notifier.identifier_name, notifier
  parent :notifiers
end