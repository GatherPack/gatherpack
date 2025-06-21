class Ledger < ApplicationRecord
  belongs_to :team
  has_many :ledger_ownerships, dependent: :destroy
  has_many :ledger_entries, dependent: :destroy
  monetize :balance_cents

  def owners
    ledger_ownerships.map(&:owner)
  end

  def identifier_icon
    "receipt"
  end

  def refresh_balance
    update(balance_cents: ledger_entries.where(parent_id: nil, finalized: true).sum(:amount_cents))
  end
end
