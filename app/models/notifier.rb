class Notifier < ApplicationRecord
  belongs_to :person
  store_accessor :schedule, :schedule_type

  SCHEUDLE_TYPES = [ :immediate ]
end
