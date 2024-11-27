class EventType < ApplicationRecord
  has_paper_trail versions: { class_name: "Version" }
  has_many :events

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ['name']
  end
end
