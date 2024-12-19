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
