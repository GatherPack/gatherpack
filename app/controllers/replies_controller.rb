class RepliesController < InternalController
  before_action :set_question
  before_action :set_reply, only: %i[edit update destroy]

  def create
    @reply = authorize Reply.new(reply_params)
    @reply.question = @question
    @reply.person = current_user.person

    if @reply.save
      redirect_to @question, notice: "Reply posted.", status: :see_other
    else
      redirect_to @question, alert: "Reply could not be posted.", status: :see_other
    end
  end

  def edit
  end

  def update
    if @reply.update(reply_params)
      redirect_to @question, notice: "Reply updated.", status: :see_other
    else
      redirect_to @question, alert: "Reply could not be updated.", status: :see_other
    end
  end

  def destroy
    @reply.destroy!
    redirect_to @question, notice: "Reply deleted.", status: :see_other
  end

  private

  def set_question
    @question = authorize policy_scope(Question).find(params[:question_id])
  end

  def set_reply
    @reply = authorize @question.replies.find(params[:id])
  end

  def reply_params
    params.require(:reply).permit(:content, :parent_id)
  end
end
