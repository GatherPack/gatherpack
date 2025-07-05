class MailboxAssignment < ApplicationRecord
  has_neat_id :mxa
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :mailbox
  belongs_to :target, polymorphic: true
end
