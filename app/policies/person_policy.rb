class PersonPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.joins(memberships: :team).where( teams: {id: user.teams.select(:id) }).distinct
      end
    end
  end
end
