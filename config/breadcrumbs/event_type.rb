crumb :event_types do
  link "Event_types", event_types_path
end

crumb :event_type do |event_type|
  link event_type.identifier_name, event_type
  parent :event_types
end