crumb :budgets do
  link "Budgets", budgets_path
end

crumb :budget do |budget|
  link budget.new_record? ? "New budget" : budget.identifier_name, budget
  parent :budgets
end
