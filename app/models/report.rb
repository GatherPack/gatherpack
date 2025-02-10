class Report < ApplicationRecord
  has_paper_trail versions: { class_name: "AuditLog" }

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[ name updated_at ]
  end
end
