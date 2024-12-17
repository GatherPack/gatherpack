class TimeClockPunchPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      elsif person.manager?
        scope.where(person: (person.managed_teams.map(&:person_ids).flatten << person.id).uniq)
      else
        scope.where(person: person)
      end
    end
  end

  def update?
    # punch of person who is managed by user, or punch of user with no associated period or with period of permission "added_by_user" or "added_by_team_member"
    person.managed_people.include?(record.person) || (person == record.person && record.time_clock_period.nil? ? true : %w[ added_by_user added_by_team_member ].include?(record.time_clock_period.permission))
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end
end
