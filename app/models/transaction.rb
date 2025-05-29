class Transaction < ApplicationRecord
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :account
  belongs_to :created_by, polymorphic: true
  monetize :amount_cents
end
