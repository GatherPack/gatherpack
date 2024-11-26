class PagePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(team: person.teams).or(scope.where(team_id: "")).or(scope.where(viewer: "public"))
      end
    end
  end

  def show?
    return true if user.admin
    case record.viewer
    when 'public'
      true
    when 'user'
      user.present?
    when 'team'
      record.team ? person.teams.include?(record.team) : user.admin
    when 'manager'
      record.team ? record.team.managers.include?(person) : user.admin
    when 'admin'
      user.admin
    else
      user.admin
    end
  end

  def new?
    user.admin? || person.manager? || person.teams.present?
  end

  def update?
    return true if user.admin
    case record.editor
    when 'public'
      true
    when 'user'
      user.present?
    when 'team'
      record.team ? person.teams.include?(record.team) : user.admin
    when 'manager'
      record.team ? record.team.managers.include?(person) : user.admin
    when 'admin'
      user.admin
    else
      user.admin
    end
  end

  def create?
    update?
  end

  def destroy?
    update?
  end
end
