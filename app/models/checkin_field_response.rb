class CheckinFieldResponse < ApplicationRecord
  belongs_to :checkin
  belongs_to :checkin_field
end
