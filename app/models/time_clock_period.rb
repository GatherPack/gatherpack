class TimeClockPeriod < ApplicationRecord
  belongs_to :team, :optional
  enum :permission, added_by_admin: 0, added_by_manager: 1, added_by_team_member: 2, added_by_participant: 3, added_by_user: 4
end
