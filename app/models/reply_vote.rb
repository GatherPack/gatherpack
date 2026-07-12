class ReplyVote < ApplicationRecord
  has_paper_trail versions: { class_name: "AuditLog" }

  belongs_to :reply
  belongs_to :person
  belongs_to :question

  validates :person_id, uniqueness: { scope: :question_id }

  validate :reply_belongs_to_question

  private

  def reply_belongs_to_question
    errors.add(:reply, "must belong to this question") if reply && reply.question_id != question_id
  end
end
