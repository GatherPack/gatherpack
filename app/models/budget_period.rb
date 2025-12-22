class BudgetPeriod < ApplicationRecord
  has_neat_id :bpd
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :team
  has_many :budgets, dependent: :destroy

  def identifier_icon
    "file-invoice-dollar"
  end
end
