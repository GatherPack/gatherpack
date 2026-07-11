crumb :membership_applications do |team_or_person|
  if team_or_person.is_a?(Team)
    team = team_or_person
    link "Applications", team_membership_applications_path(team)
    parent :team, team
  else
    person = team_or_person
    link "Applications", person_membership_applications_path(person)
    parent :person, person
  end
end

crumb :membership_application do |membership_application, team_or_person|
  link membership_application.new_record? ? "New Application" : membership_application.identifier_name
  parent :membership_applications, team_or_person
end
