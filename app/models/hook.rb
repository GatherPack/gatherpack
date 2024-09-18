class Hook < ApplicationRecord
  def self.catalog
    ['announcements', 'badges', 'events', 'memberships', 'people', 'teams', 'users'].map do |k|
      ['create', 'update', 'destroy'].map { |e| [k.singularize, e].join(' - ') }
    end.flatten
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[ name event ]
  end

  def run(model)
    eval(code, binding, name, 0)
  end
end
