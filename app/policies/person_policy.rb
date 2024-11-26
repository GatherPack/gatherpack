class PersonPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(id: (person.teams.map(&:person_ids).flatten << person.id)).distinct
      end
    end
  end

  def update?
    record == person || user.admin? || (person.managed_teams & record.teams).any?
  end

  def destroy?
    user.admin?
  end
end
