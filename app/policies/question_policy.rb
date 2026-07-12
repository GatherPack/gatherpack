class QuestionPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(team_id: person.all_teams.map(&:id))
      end
    end
  end

  def create?
    user.admin || person.all_teams.exists?(record.team_id)
  end

  def update?
    user.admin || record.person_id == person.id || manager_of_team?(record.team)
  end

  def destroy?
    user.admin || manager_of_team?(record.team)
  end

  def close?
    update?
  end

  def reopen?
    update?
  end

  def move?
    user.admin || manager_of_team?(record.team)
  end

  def upvote?
    show?
  end

  private

  def manager_of_team?(team)
    team && person.all_managed_teams.include?(team)
  end
end
