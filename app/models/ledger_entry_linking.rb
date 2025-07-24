class LedgerEntryLinking < ApplicationRecord
  has_neat_id :leln
  belongs_to :ledger_entry
  belongs_to :ledger_entry_link
end
