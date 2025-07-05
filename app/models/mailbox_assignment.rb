class MailboxAssignment < ApplicationRecord
  has_neat_id :mxa
  belongs_to :mailbox
  belongs_to :target, polymorphic: true
end
