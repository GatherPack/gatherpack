class Mailbox < ApplicationRecord
  has_many :mailbox_messages
  has_many :mailbox_assignments

  def self.ransackable_attributes(auth_object = nil)
    [ 'address' ]
  end

  def identifier_name
    address
  end

  def messages
    mailbox_messages
  end

  def targets
    mailbox_assignments.map(&:target)
  end
end