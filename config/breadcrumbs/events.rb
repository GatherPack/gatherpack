crumb :events do
  link "Events", events_path
end

crumb :event do |event|
  link event.identifier_name, event
  parent :events
end
