# frozen_string_literal: true

class AdminPolicy < ApplicationPolicy
  def index?
    user&.admin
  end

  def show?
    user&.admin
  end

  def create?
    user&.admin
  end

  def update?
    user&.admin
  end

  def destroy?
    user&.admin
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope
    end
  end
end
