class LedgerOwnership < ApplicationRecord
  has_neat_id :leo
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :ledger
  belongs_to :owner, polymorphic: true

  def identifier_name
    "#{owner.identifier_name} => #{ledger.identifier_name}"
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "ledger_id", "owner_type", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "ledger" ]
  end
end
