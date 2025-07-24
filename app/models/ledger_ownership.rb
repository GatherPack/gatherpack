class LedgerOwnership < ApplicationRecord
  has_neat_id :leo
  belongs_to :ledger
  belongs_to :owner, polymorphic: true
end
