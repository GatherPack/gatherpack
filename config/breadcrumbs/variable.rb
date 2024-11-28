crumb :variables do
  link "Variables", variables_path
end

crumb :variable do |variable|
  link variable.identifier_name, variable
  parent :variables
end
