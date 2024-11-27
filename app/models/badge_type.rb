class BadgeType < ApplicationRecord
  has_paper_trail versions: { class_name: "Version" }
  has_many :badges

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ['name']
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
