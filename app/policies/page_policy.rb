class PagePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.where(viewer: "public") unless user.present?
      if user.admin
        scope.all
      else
        scope.where(team: person.all_teams).or(scope.where(team_id: "")).or(scope.where(viewer: "public")).or(scope.where(viewer: "user"))
      end
    end
  end

  def show?
    return true if user.present? && user.admin
    case record.viewer
    when "public"
      true
    when "user"
      user.present?
    when "team"
      record.team ? person.all_teams.include?(record.team) : user.admin
    when "manager"
      record.team ? record.team.manager?(person) : user.admin
    when "admin"
      user.admin
    else
      user.admin
    end
  end

  def new?
    user.present? && (user.admin? || person.manager? || person.all_teams.present?)
  end

  def update?
    return false unless user.present?
    return true if user.admin
    case record.editor
    when "user"
      user.present?
    when "team"
      record.team ? person.all_teams.include?(record.team) : user.admin
    when "manager"
      record.team ? record.team.manager?(person) : user.admin
    when "admin"
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
