class CheckinFieldResponse < ApplicationRecord
  belongs_to :checkin
  belongs_to :checkin_field

  def permission_check(created_by)
    case checkin_field.permission
    when 'added_by_admin'
      created_by.user.admin?
    when 'added_by_manager'
      created_by.managed_teams.present?
    when 'added_by_team_member'
      created_by.teams.present?
    when 'added_by_participant'
      self.checkin.where(person: created_by).distinct.present?
    when 'added_by_user'
      true
    end
  end
end
