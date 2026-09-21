class Shortcut < ApplicationRecord
  belongs_to :team

  def self.ransackable_attributes(auth_object = nil)
    [ "name", "target", "team_id", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "team" ]
  end
end
