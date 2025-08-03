crumb :person_activity do |person|
  link "Activity", person_activity_index_path(person)
  parent :person, person
end
