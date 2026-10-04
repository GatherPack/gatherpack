class BudgetPeriod < ApplicationRecord
  has_neat_id :bpd
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :team
  has_many :budgets, dependent: :destroy

  def identifier_icon
    "file-invoice-dollar"
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "name", "starts_at", "ends_at", "team_id", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "team" ]
  end
end
