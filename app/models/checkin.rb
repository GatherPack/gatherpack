class Checkin < ApplicationRecord
  has_neat_id :cki
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :person
  belongs_to :event
  has_many :checkin_field_responses, dependent: :destroy
  accepts_nested_attributes_for :checkin_field_responses

  validates :person, presence: true, uniqueness: { scope: :event, message: "has already been checked in" }
  validate :check_limit

  before_update :check_attributes
  before_validation :refresh_fields

  attr_accessor :created_by

  def self.ransackable_attributes(auth_object = nil)
    [ "person.display_name" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "person" ]
  end

  def identifier_name
    "#{person.identifier_name}'s checkin"
  end

  def refresh_fields
    event.event_type.checkin_fields.each do |field|
      unless checkin_field_responses.any? { |r| r.checkin_field_id == field.id }
        response = checkin_field_responses.build(checkin: self, checkin_field: field)
        response.save unless self.new_record?
      end
    end
    checkin_field_responses.each do |response|
      response.delete unless event.event_type.checkin_fields.any? { |f| f.id == response.checkin_field_id }
    end
  end

  private

  def check_attributes
    self.checkin_field_responses.each do |r|
      if !r.permission_check(self.created_by)
        r.response = r.response_was
      end
    end
  end

  def check_limit
    limit = self.event.checkin_limit || 0

    if limit > 0 && self.event.checkins.count >= limit
      errors.add(:base, "Unable to checkin, checkin count exceeds checkin limit for this event.")
    end
  end
end
