class Report < ApplicationRecord
  has_paper_trail versions: { class_name: "AuditLog" }

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[ name ]
  end

  def run(model)
    eval(code, binding, name, 0)
  end
end
