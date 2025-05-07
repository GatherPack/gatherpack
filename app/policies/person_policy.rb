class PersonPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(id: (person.all_teams.map(&:person_ids).flatten << person.id)).distinct
      end
    end
  end

  def update?
    record == person || user.admin? || (person.all_managed_teams & record.all_teams).any?
  end

  def destroy?
    user.admin?
  end
end
