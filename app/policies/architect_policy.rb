# frozen_string_literal: true

class ArchitectPolicy < ApplicationPolicy
  def index?
    user&.architect
  end

  def show?
    user&.architect
  end

  def create?
    user&.architect
  end

  def update?
    user&.architect
  end

  def destroy?
    user&.architect
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope
    end
  end
end
