class Token < ApplicationRecord
  belongs_to :tokenable, polymorphic: true
end
