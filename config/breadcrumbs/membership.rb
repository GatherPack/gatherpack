crumb :memberships do |team|
  link "Memberships", team_memberships_path(team)
  parent :team, team
end

crumb :membership do |membership|
  link membership.new_record? ? "New membership" : membership.identifier_name
  parent :memberships, membership.team
end
