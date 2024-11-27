class Report < ApplicationRecord
  has_paper_trail versions: { class_name: "Version" }

  validates :name, presence: true
end
