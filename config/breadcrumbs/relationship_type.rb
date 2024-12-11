crumb :relationship_types do
  link 'Relationship Types', relationship_types_path
end

crumb :relationship_type do |relationship_type|
  link relationship_type.identifier_name, relationship_type
  parent :relationship_types
end
