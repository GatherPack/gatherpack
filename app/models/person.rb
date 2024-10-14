class Person < ApplicationRecord
  include CanBeHooked
  belongs_to :user, optional: true
  has_many :memberships
  has_many :teams, through: :memberships
  has_many :badge_assignments
  has_many :badges, through: :badge_assignments
  has_many :tokens, as: :tokenable
  has_many :account_relationships, as: :holder
  has_many :accounts, through: :account_relationships
  before_save :check_display_name
  accepts_nested_attributes_for :user
  has_one_attached :avatar

  def self.ransackable_attributes(auth_object = nil)
    [ 'address', 'birthday', 'created_at', 'dietary_restrictions', 'display_name', 'first_name', 'gender', 'id', 'last_name', 'phone_number', 'shirt_size', 'updated_at', 'user_id' ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ 'user' ]
  end

  def admin?
    user&.admin
  end

  def manager?
    memberships.where(manager: true).any?
  end

  private

  def check_display_name
    self.display_name = first_name + ' ' + last_name if display_name.blank? && !first_name.blank? && !last_name.blank?
  end
end
