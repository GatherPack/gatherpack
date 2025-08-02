class Operation < ApplicationRecord
  has_neat_id :op
  has_paper_trail versions: { class_name: "AuditLog" }

  PERMISSION_LEVELS = %w[ public user team manager admin ]
  SCOPES = %w[ collection member ]
  MODELS = %w[ Announcement Badge CalendarNote Checkin Event LedgerEntry Ledger Mailbox MailboxMessage Membership Page Person Team TimeClockPeriod Token ]

  validates :name, presence: true
  validate :permissions_make_sense

  def self.ransackable_attributes(auth_object = nil)
    [ "name", "model", "code", "template", "updated_at" ]
  end

  def identifier_icon
    "bolt"
  end

  private

  def permissions_make_sense
    errors.add(:permission, "can't be 'related' for collection actions") if permission == "related" && scope == "collection"
    errors.add(:permission, "can't be 'team' for collection actions") if permission == "team" && scope == "collection"
  end
end
