class RelationshipPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        people = (person.all_teams.map(&:person_ids).flatten << person.id).uniq
        scope.where(parent_id: people).and(scope.where(child_id: people))
          .or(scope.where(parent_id: person.id).or(scope.where(child_id: person.id)))
          .distinct
      end
    end
  end

  def new?
    true
  end

  def create?
    true
  end

  def destroy?
    user.admin? || record.parent == user || record.child == user
  end
end
