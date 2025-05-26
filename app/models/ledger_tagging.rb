class LedgerTagging < ApplicationRecord
  belongs_to :ledger_entry
  belongs_to :ledger_tag
end
