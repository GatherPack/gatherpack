class Checkin < ApplicationRecord
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :person
  belongs_to :event
  has_many :checkin_field_responses, dependent: :destroy
  accepts_nested_attributes_for :checkin_field_responses

  validates :person, presence: true
  
  def self.ransackable_attributes(auth_object = nil)
    ['person.display_name']
  end

  def self.ransackable_associations(auth_object = nil)
    ['person']
  end
end
