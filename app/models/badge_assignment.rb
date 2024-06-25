class BadgeAssignment < ApplicationRecord
  belongs_to :badge
  belongs_to :person
end
