crumb :events do
  link "Events", events_path
end

crumb :event do |event|
  link event.identifier_name, event
  parent :events
end

crumb :checkin do |checkin|
  link checkin.identifier_name
  parent :event, checkin.event
end

crumb :arrange_event do |event|
  link "Arrange", arrange_event_path(event)
  parent :event, event
end

crumb :print_event do |event|
  link "Print", print_event_path(event)
  parent :event, event
end
