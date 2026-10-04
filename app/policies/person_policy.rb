class PersonPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        # A subquery, not a materialised ID array: this scope runs on every
        # keystroke of live search, so it must compose with Ransack and
        # Kaminari and never load ids into Ruby.
        scope.where(Person::VISIBLE_PEOPLE_CONDITION, person_id: person.id)
      end
    end
  end

  def show?
    record == person || user.admin? || (person.all_teams & record.all_teams).any?
  end

  # The extra read-only member pages share the same visibility rule as #show.
  alias_method :recent_activity?, :show?
  alias_method :calendar?, :show?
  alias_method :statistics?, :show?
  alias_method :relationships?, :show?
  alias_method :teams?, :show?

  def update?
    record == person || user.admin? || (person.all_managed_teams & record.all_teams).any?
  end

  def destroy?
    user.admin?
  end

  def impersonate?
    user.admin?
  end

  def stop_impersonating?
    user.admin?
  end
end
