class MembershipApplicationPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(person_id: person.id)
          .or(scope.where(team_id: person.all_managed_teams.select(:id)))
      end
    end
  end

  def index?
    user.admin || person.all_managed_teams.include?(record.try(:team)) || record.try(:person_id) == person&.id
  end

  def show?
    index?
  end

  def create?
    return false unless record.try(:team)&.requires_approval?
    return false if person.teams.include?(record.team)
    return false if record.team.membership_applications.pending.exists?(person_id: person.id)
    true
  end

  def update?
    user.admin || record.team.manager?(person)
  end

  def destroy?
    user.admin || (record.person_id == person.id && record.pending?)
  end
end
