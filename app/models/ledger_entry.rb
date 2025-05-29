class LedgerEntry < ApplicationRecord
  belongs_to :ledger
  belongs_to :created_by, polymorphic: true
  has_many :ledger_taggings
  has_many :ledger_tags, through: :ledger_taggings
  has_many :ledger_entry_linkings
  has_many :ledger_entry_links, through: :ledger_entry_linkings
  has_many :child_entries, class_name: "LedgerEntry", foreign_key: :parent_id
  belongs_to :parent, optional: true, class_name: "LedgerEntry", touch: true

  accepts_nested_attributes_for :child_entries, allow_destroy: true, reject_if: :unsplit?

  has_many_attached :receipts

  monetize :amount_cents

  before_save :mirror_amount
  after_commit :refresh_ledger
  before_destroy :destroy_linked_entries

  scope :deposits, -> { where("amount_cents >= 0") }
  scope :expenses, -> { where("amount_cents < 0") }

  def refresh_ledger
    ledger.refresh_balance
  end

  def linked_entries
    LedgerEntry.where(id: (ledger_entry_links.flat_map(&:ledger_entries).map(&:id) - [ id ]))
  end

  def destroy_linked_entries
    links = ledger_entry_links
    entries = links.flat_map(&:ledger_entries)
    linkings = links.flat_map(&:ledger_entry_linkings)
    ledgers = entries.flat_map(&:ledger).uniq
    taggings = entries.flat_map(&:ledger_taggings)
    linkings.each(&:delete)
    links.each(&:delete)
    taggings.each(&:delete)
    entries.each(&:delete)

    ledgers.each(&:refresh_balance)
  end

  def mirror_amount
    if transfer_mirror && amount_cents > 0
      self.amount_cents = -amount_cents
    end
  end

  def split?
    child_entries.present?
  end

  def unsplit?
    !split?
  end

  def splittable?
    !split? && linked_entries.none? && ledger_taggings.none?
  end

  def unsplittable?
    split? && linked_entries.none?
  end

  def split_difference
    Money.new(child_entries.sum(:amount_cents) - amount_cents)
  end

  def fully_split?
    split_difference == 0
  end
end
