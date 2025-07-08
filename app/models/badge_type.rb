class BadgeType < ApplicationRecord
  has_neat_id :bdtp
  has_paper_trail versions: { class_name: "AuditLog" }
  has_many :badges

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    [ "name", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
