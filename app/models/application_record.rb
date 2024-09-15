class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  before_create :maybe_assign_id

  def identifier_name
    try(:display_name) || try(:name) || try(:title) || try(:id)
  end

  private

  def maybe_assign_id
    self.id = SecureRandom.uuid if self.id.blank?
  end
end
