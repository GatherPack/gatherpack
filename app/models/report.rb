class Report < ApplicationRecord
  has_paper_trail versions: { class_name: "AuditLog" }

  validates :name, presence: true
end
