class LedgerEntryLink < ApplicationRecord
  has_many :ledger_entry_linkings, dependent: :destroy
  has_many :ledger_entries, through: :ledger_entry_linkings
end
