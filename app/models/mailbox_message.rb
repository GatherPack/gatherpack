class MailboxMessage < ApplicationRecord
  belongs_to :mailbox
  has_many_attached :attachments

  def self.ransackable_attributes(auth_object = nil)
    [ 'subject', 'body', 'from', 'updated_at' ]
  end

  def identifier_name
    subject
  end
end
