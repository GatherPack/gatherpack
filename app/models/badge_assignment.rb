class BadgeAssignment < ApplicationRecord
  include CanBeHooked
  belongs_to :badge
  belongs_to :person
end
