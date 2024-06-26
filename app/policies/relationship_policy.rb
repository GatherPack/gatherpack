class RelationshipPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(id: (person.relationship_parent_ids+person.relationship_child_ids))
      end
    end
  end
end
