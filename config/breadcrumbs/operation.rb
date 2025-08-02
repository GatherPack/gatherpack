crumb :operations do
  link "Operations", operations_path
end

crumb :operation do |operation|
  link operation.identifier_name, operation
  parent :operations
end