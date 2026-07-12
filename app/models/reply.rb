class Reply < ApplicationRecord
  has_neat_id :rpl
  include CanBeHooked

  has_paper_trail versions: { class_name: "AuditLog" }

  belongs_to :question
  belongs_to :person
  belongs_to :parent, class_name: "Reply", optional: true
  has_many :children, class_name: "Reply", foreign_key: :parent_id, dependent: :destroy
  has_many :reply_votes, dependent: :destroy

  validates :content, presence: true

  scope :top_level, -> { where(parent_id: nil) }

  def self.ransackable_attributes(auth_object = nil)
    %w[content created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[question person children]
  end

  def identifier_icon
    "reply"
  end

  def vote_count
    reply_votes.count
  end
end
