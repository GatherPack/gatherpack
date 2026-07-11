class TeamPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(id: person.all_team_ids)
          .or(scope.where(join_permission: Team.join_permissions[:has_account]))
          .or(scope.where(join_permission: Team.join_permissions[:requires_approval]))
      end
    end
  end

  def new?
    person.manager?
  end

  def create?
    person.admin? || (person.manager? && !record.parent.nil? && person.teams.include?(record.parent))
  end

  def update?
    has_perms
  end

  def permitted_attributes_for_update
    [ :name, :color, :team_type_id, :description ] + if user.admin?
      [ :join_permission, :parent_id, person_ids: [] ]
    elsif record.join_permission != "added_by_admin"
      [ :parent_id, person_ids: [] ]
    else
      []
    end
  end

  private

  def has_perms
    user.admin || record.all_managers_and_admins.include?(user.person)
  end
end
