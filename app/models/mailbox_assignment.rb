class MailboxAssignment < ApplicationRecord
  belongs_to :mailbox
  belongs_to :target, polymorphic: true
end
