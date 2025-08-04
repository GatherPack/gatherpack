crumb :people do
  link 'People', people_path
end

crumb :person do |person|
  link person.new_record? ? "New person" : person.identifier_name, person
  parent :people
end

crumb :relationship do |person, relationship|
  link 'New Relationship'
  parent :person, person
end

crumb :user do |person|
  link 'User Information'
  parent :person, person
end
