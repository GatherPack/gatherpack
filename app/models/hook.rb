class Hook < ApplicationRecord
  def self.catalog
    ['announcements', 'badges', 'events', 'memberships', 'people', 'teams', 'users'].map do |k|
      ['create', 'update', 'destroy'].map { |e| [k, e].join('.') }
    end.flatten
  end

  def run(model)
    eval(code, binding, name, 0)
  end
end
