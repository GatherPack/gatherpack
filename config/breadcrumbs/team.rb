crumb :teams do
  link "Teams", teams_path
end

crumb :team do |team|
  link team.new_record? ? "New team" : team.identifier_name, team
  parent :teams
end

crumb :team_badges do |team|
  link "Badges", badges_team_path(team)
  parent :team, team
end

crumb :team_pages do |team|
  link "Pages", pages_team_path(team)
  parent :team, team
end

crumb :team_events do |team|
  link "Events", events_team_path(team)
  parent :team, team
end
