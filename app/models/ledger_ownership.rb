class LedgerOwnership < ApplicationRecord
  has_neat_id :leo
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :ledger
  belongs_to :owner, polymorphic: true

  def self.ransackable_attributes(auth_object = nil)
    %w[ updated_at ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def identifier_name
    "#{owner.identifier_name} => #{ledger.identifier_name}"
  end
end
