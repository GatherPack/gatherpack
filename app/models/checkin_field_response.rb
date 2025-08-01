class CheckinFieldResponse < ApplicationRecord
  has_neat_id :cfr
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :checkin
  belongs_to :checkin_field

  def permission_check(created_by)
    case checkin_field.permission
    when "added_by_admin"
      created_by.user.admin?
    when "added_by_manager"
      created_by.all_managed_teams.present? || created_by.user.admin?
    when "added_by_team_member"
      created_by.teams.present?
    when "added_by_participant"
      checkin.event.checkins.where(person: created_by).distinct.present? || created_by.user.admin?
    when "added_by_user"
      true
    end
  end
end
