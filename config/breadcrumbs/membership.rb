crumb :memberships do |team_or_person|
  if team_or_person.is_a?(Team)
    team = team_or_person
    link "Memberships", team_memberships_path(team)
    parent :team, team
  else
    person = team_or_person
    link "Memberships", person_memberships_path(person)
    parent :person, person
  end
end

crumb :membership do |membership, team_or_person|
  link membership.new_record? ? "New membership" : membership.identifier_name
  parent :memberships, team_or_person
end
