class LedgerOwnership < ApplicationRecord
  belongs_to :ledger
  belongs_to :owner, polymorphic: true
end
