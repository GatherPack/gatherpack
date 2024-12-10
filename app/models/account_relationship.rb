class AccountRelationship < ApplicationRecord
  belongs_to :account
  belongs_to :holder, polymorphic: true
end
