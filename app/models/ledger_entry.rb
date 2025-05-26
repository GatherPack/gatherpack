class LedgerEntry < ApplicationRecord
  belongs_to :ledger
  belongs_to :created_by, polymorphic: true
  has_many :ledger_taggings
  has_many :ledger_tags, through: :ledger_taggings
  has_many :ledger_entry_linkings
  has_many :ledger_entry_links, through: :ledger_entry_linkings

  has_many_attached :receipts

  monetize :amount_cents

  after_commit :refresh_ledger
  before_destroy :destroy_linked_entries

  scope :deposits, -> { where("amount_cents >= 0") }
  scope :expenses, -> { where("amount_cents < 0") }

  def refresh_ledger
    ledger.refresh_balance
  end

  def destroy_linked_entries
    links = ledger_entry_links
    entries = links.flat_map(&:ledger_entries)
    linkings = links.flat_map(&:ledger_entry_linkings)
    ledgers = entries.flat_map(&:ledger).uniq
    linkings.each(&:delete)
    links.each(&:delete)
    entries.each(&:delete)

    ledgers.each(&:refresh_balance)
  end
end
