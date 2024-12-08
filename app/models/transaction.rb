class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :created_by, polymorphic: true
  monetize :amount_cents
end
