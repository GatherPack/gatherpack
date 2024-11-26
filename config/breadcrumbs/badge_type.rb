crumb :badge_types do
  link "Badge Types", badge_types_path
end

crumb :badge_type do |badge_type|
  link badge_type.identifier_name, badge_type
  parent :badge_types
end