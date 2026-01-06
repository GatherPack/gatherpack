class Ledger < ApplicationRecord
  has_neat_id :leg
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :team
  has_many :ledger_ownerships, dependent: :destroy
  has_many :ledger_entries, dependent: :destroy
  monetize :balance_cents

  after_save :refresh_balance

  def self.ransackable_attributes(auth_object = nil)
    ["name", "team_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["ledger_entries", "ledger_ownerships", "team"]
  end

  def owners
    ledger_ownerships.map(&:owner)
  end

  def identifier_icon
    "receipt"
  end

  def refresh_balance
    update_column(:balance_cents, ledger_entries.where(parent_id: nil, finalized: true, failed: false).sum(:amount_cents))
  end
end
