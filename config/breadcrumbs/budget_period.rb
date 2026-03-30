crumb :budget_periods do
  link "Budget Periods", budget_periods_path
end

crumb :budget_period do |budget_period|
  link budget_period.new_record? ? "New budget period" : budget_period.identifier_name, budget_period
  parent :budget_periods
end
