class LedgerEntryLinking < ApplicationRecord
  belongs_to :ledger_entry
  belongs_to :ledger_entry_link
end
