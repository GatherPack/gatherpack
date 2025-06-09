class Checkin < ApplicationRecord
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :person
  belongs_to :event
  has_many :checkin_field_responses, dependent: :destroy
  accepts_nested_attributes_for :checkin_field_responses

  validates :person, presence: true, uniqueness: { scope: :event, message: "has already been checked in" }

  before_update :check_attributes
  after_initialize :set_up_fields

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

  private

  def set_up_fields
    event.event_type.checkin_fields.each do |field|
      checkin_field_responses.build(checkin: self, checkin_field: field) unless checkin_field_responses.where(checkin_field: field).present?
    end
  end

  def check_attributes
    self.checkin_field_responses.each do |r|
      if !r.permission_check(self.created_by)
        r.response = r.response_was
      end
    end
  end
end
