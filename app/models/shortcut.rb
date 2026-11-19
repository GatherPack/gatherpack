class Shortcut < ApplicationRecord
  belongs_to :team

  def self.ransackable_attributes(auth_object = nil)
    %w[ name icon color target updated_at ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
