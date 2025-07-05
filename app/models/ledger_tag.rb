class LedgerTag < ApplicationRecord
  has_neat_id :ltg
  has_many :ledger_taggings
  has_many :ledger_entries, through: :ledger_taggings

  def identifier_icon
    "stamp"
  end
end
