class TeamPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(id: person.team_ids)
      end
    end
  end

  def new?
    user.admin
  end

  def update?
    has_perms
  end

  def permitted_attributes_for_update
    if user.admin?
      [ :name, :color, :team_type_id, :join_permission, person_ids: [] ]
    else
      if record.join_permission == 'added_by_admin'
        [ :name, :color, :team_type_id ]
      else
        [ :name, :color, :team_type_id, person_ids: [] ]
      end
    end
  end

  private
  def has_perms
    user.admin || record.managers.include?(user.person)
  end
end
