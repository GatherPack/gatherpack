class LedgerEntryLink < ApplicationRecord
  has_neat_id :lel
  has_many :ledger_entry_linkings, dependent: :destroy
  has_many :ledger_entries, through: :ledger_entry_linkings
end
