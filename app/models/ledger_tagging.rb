class LedgerTagging < ApplicationRecord
  has_neat_id :ltt
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :ledger_entry
  belongs_to :ledger_tag
end
