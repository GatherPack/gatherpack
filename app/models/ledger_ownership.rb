class LedgerOwnership < ApplicationRecord
  has_neat_id :leo
  belongs_to :ledger
  belongs_to :owner, polymorphic: true

  def identifier_name
    "#{owner.identifier_name} => #{ledger.identifier_name}"
  end
end
