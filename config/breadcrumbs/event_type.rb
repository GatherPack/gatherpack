crumb :event_types do
  link "Event Types", event_types_path
  parent :setup
end

crumb :event_type do |event_type|
  link event_type.new_record? ? "New event type" : event_type.identifier_name, event_type
  parent :event_types
end
