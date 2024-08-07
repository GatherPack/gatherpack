crumb :people do
  link "People", people_path
end

crumb :person do |person|
  link person.identifier_name, person
  parent :people
end