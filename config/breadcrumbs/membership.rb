crumb :memberships do |team|
  link "Memberships", team_memberships_path(team)
  parent :team, team
end
