crumb :teams do
  link "Teams", teams_path
end

crumb :team do |team|
  link team.identifier_name, team
  parent :teams
end
