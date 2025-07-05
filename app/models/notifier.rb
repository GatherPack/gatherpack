class Notifier < ApplicationRecord
  has_neat_id :ntf
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :person

  store_accessor :schedule, :schedule_type

  SCHEDULE_TYPES = [ :immediate ]
end
