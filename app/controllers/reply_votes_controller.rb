class ReplyVotesController < InternalController
  before_action :set_question

  def upvote
    reply = @question.replies.find(params[:id])
    existing_vote = ReplyVote.find_by(person: current_user.person, question: @question)

    if existing_vote&.reply_id == reply.id
      existing_vote.destroy
      redirect_to @question, notice: "Vote removed.", status: :see_other
    elsif existing_vote
      existing_vote.update!(reply: reply)
      redirect_to @question, notice: "Vote updated.", status: :see_other
    else
      vote = ReplyVote.new(reply: reply, person: current_user.person, question: @question)
      authorize vote
      vote.save!
      redirect_to @question, notice: "Vote recorded.", status: :see_other
    end
  end

  def unvote
    ReplyVote.where(person: current_user.person, question: @question).destroy_all
    redirect_to @question, notice: "Vote removed.", status: :see_other
  end

  private

  def set_question
    @question = authorize policy_scope(Question).find(params[:question_id])
  end
end
