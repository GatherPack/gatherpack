class LedgerTag < ApplicationRecord
  has_neat_id :ltg
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }
  has_many :ledger_taggings
  has_many :ledger_entries, through: :ledger_taggings
  has_many :budget_taggings, dependent: :destroy
  has_many :budgets, through: :budget_taggings

  def identifier_icon
    "stamp"
  end
end
