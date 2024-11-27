class Badge < ApplicationRecord
  include CanBeHooked
  has_paper_trail versions: { class_name: "Version" }
  belongs_to :badge_type
  belongs_to :team, optional: true
  has_many :badge_assignments
  has_many :people, through: :badge_assignments

  validates :name, presence: true
  validates :color, presence: true
  validates :short, presence: true
  validates :badge_type, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ['badge_type_id', 'description', 'name', 'short', 'team_id']
  end

  def self.ransackable_associations(auth_object = nil)
    ['badge_type', 'team']
  end

end
