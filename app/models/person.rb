class Person < ApplicationRecord
  belongs_to :user, optional: true
  before_save :check_display_name
  accepts_nested_attributes_for :user

  def self.ransackable_attributes(auth_object = nil)
    ["address", "birthday", "created_at", "dietary_restrictions", "display_name", "first_name", "gender", "id", "last_name", "phone_number", "shirt_size", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end

  private

  def check_display_name
    self.display_name = first_name + ' ' + last_name if display_name.blank? && !first_name.blank? && !last_name.blank?
  end
end
