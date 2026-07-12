class Question < ApplicationRecord
  has_neat_id :qst
  include CanBeHooked

  has_paper_trail versions: { class_name: "AuditLog" }

  belongs_to :team
  belongs_to :person
  has_many :replies, dependent: :destroy
  has_many :reply_votes, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true

  scope :open_questions, -> { where(closed: false) }
  scope :closed_questions, -> { where(closed: true) }

  def self.ransackable_attributes(auth_object = nil)
    %w[title content closed team_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[team person replies]
  end

  def identifier_icon
    "comment"
  end

  def promoted_replies(limit: 3)
    replies
      .left_joins(:reply_votes)
      .group("replies.id")
      .having("COUNT(reply_votes.id) > 0")
      .order("COUNT(reply_votes.id) DESC, replies.created_at ASC")
      .limit(limit)
  end

  def top_replies_for(person)
    promoted = promoted_replies(limit: 3).pluck(:id)
    remaining = replies.where(parent_id: nil).where.not(id: promoted).order(created_at: :asc)

    { promoted: promoted, remaining: remaining }
  end

  def voted_reply_for(person)
    reply_votes.find_by(person: person)&.reply
  end

  def vote_counts
    reply_votes.group(:reply_id).count
  end
end
