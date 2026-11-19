class LedgerEntryLink < ApplicationRecord
  has_neat_id :lel
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }
  has_many :ledger_entry_linkings, dependent: :destroy
  has_many :ledger_entries, through: :ledger_entry_linkings

  def self.ransackable_attributes(auth_object = nil)
    %w[ updated_at ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
