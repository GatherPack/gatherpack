class Hook < ApplicationRecord
  def self.catalog
    targets = ['announcements', 'badges', 'badge_assignments', 'events', 'checkin', 'memberships', 'people', 'teams', 'users', 'accounts', 'transactions', 'page', 'token'].map do |k|
      ['create', 'update', 'destroy'].map { |e| [k.singularize, e].join(' - ') }
    end.flatten
    
    targets << 'token - activate'

    targets.sort
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[ name event ]
  end

  def run(model)
    eval(code, binding, name, 0)
  end
end
