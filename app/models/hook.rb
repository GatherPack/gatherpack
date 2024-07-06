class Hook < ApplicationRecord
  def self.catalog
    ['announcement', 'badge', 'event', 'membership', 'person', 'team', 'user'].map do |k|
      ['create', 'update', 'destroy'].map { |e| [k, e].join('.') }
    end.flatten
  end

  def run(model)
    eval(code, binding, name, 0)
  end
end
