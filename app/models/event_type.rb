class EventType < ApplicationRecord
  has_neat_id :evtp
  has_paper_trail versions: { class_name: "AuditLog" }
  has_many :events
  has_many :checkin_fields

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    [ "name", "updated_at" ]
  end
end
