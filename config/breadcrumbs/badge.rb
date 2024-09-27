crumb :badges do
  link "Badges", badges_path
end

crumb :badge do |badge|
  link badge.identifier_name, badge
  parent :badges
end