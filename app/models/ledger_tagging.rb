class LedgerTagging < ApplicationRecord
  has_neat_id :ltt
  belongs_to :ledger_entry
  belongs_to :ledger_tag
end
