class CheckinField < ApplicationRecord
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :event_type
  has_many :checkin_field_responses
  enum :permission, added_by_admin: 0, added_by_manager: 1, added_by_team_member: 2, added_by_participant: 3, added_by_user: 4

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    [ 'name', 'permission' ]
  end
end
