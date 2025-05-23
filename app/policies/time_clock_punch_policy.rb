class TimeClockPunchPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      elsif person.manager?
        scope.where(person: (person.all_managed_teams.map(&:person_ids).flatten << person.id).uniq)
      else
        scope.where(person: person)
      end
    end
  end

  def update?
    # can update punches if admin or punch is not part of any period, i.e. added by self
    if user.admin || (person == record.person && record.time_clock_period.nil?)
      true
    # can update punches if part of a generic period with 'added_by_user' perms
    elsif record.time_clock_period.team.nil?
      person == record.person && record.time_clock_period.permission == "added_by_user"
    # can update punches if manager of punch's period's team, up to 'added_by_manager' perms
    elsif person.all_managed_teams.include?(record.time_clock_period.team)
      record.time_clock_period.permission != "added_by_admin"
    # can update punches if part of punch's period's team and the period has 'added_by_team_member' perms, or if 'added_by_user' perms, and the punch was added by self
    else
      (person.all_teams.include?(record.time_clock_period.team) && record.time_clock_period.permission == "added_by_team_member") || (person == record.person && record.time_clock_period.permission == "added_by_user")
    end
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end
end
