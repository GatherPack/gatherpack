crumb :checkin_field_responses do
  link "Checkin_field_responses", checkin_field_responses_path
end

crumb :checkin_field_response do |checkin_field_response|
  link checkin_field_response.identifier_name, checkin_field_response
  parent :checkin_field_responses
end