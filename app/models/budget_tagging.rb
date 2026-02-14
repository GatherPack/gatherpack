class BudgetTagging < ApplicationRecord
  belongs_to :budget
  belongs_to :ledger_tag
end
