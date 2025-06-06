class LedgerEntryLinkPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      # TODO: This is not great but also you're never going to get a list of these anywhere and doing this would be really complicated...
      scope.all
    end
  end
end
