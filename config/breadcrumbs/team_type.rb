crumb :team_types do
  link "Team Types", team_types_path
end

crumb :team_type do |team_type|
  link team_type.identifier_name, team_type
  parent :team_types
end