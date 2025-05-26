class TeamPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(id: person.all_team_ids).or(scope.where(join_permission: Team.join_permissions[:has_account]))
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
    [ :name, :color, :team_type_id ] + if user.admin?
      [ :join_permission, :parent_id, person_ids: [] ]
    else
      if record.join_permission != "added_by_admin"
        [ :parent_id, person_ids: [] ]
      else
        []
      end
    end
  end

  private
  def has_perms
    user.admin || record.all_managers.include?(user.person)
  end
end
