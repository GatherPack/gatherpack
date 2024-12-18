class RelationshipNodePolicy < ApplicationPolicy
  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def person
      user.person
    end

    attr_reader :user, :scope

    def resolve
      if user.admin
        scope.all
      else
        scope.all.filter do |rn|
          case rn.relationship_type.permission
          when 'added_by_admin'
            user.admin?
          when 'added_by_manager'
            person.manager?
          when 'added_by_team_member'
            person.teams.present?
          when 'added_by_participant'
            true
          when 'added_by_user'
            true
          end
        end
      end
    end
  end
end
