crumb :checkin_fields do
  link "Checkin Fields", checkin_fields_path
end

crumb :checkin_field do |checkin_field|
  link checkin_field.identifier_name, checkin_field
  parent :checkin_fields
end
