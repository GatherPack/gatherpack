class TeamType < ApplicationRecord
  has_paper_trail versions: { class_name: "AuditLog" }
  has_many :teams
  validates :name, presence: true
  validates :icon, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ['icon', 'name', 'updated_at']
  end
end
