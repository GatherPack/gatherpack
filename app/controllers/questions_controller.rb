class QuestionsController < InternalController
  before_action :set_question, only: %i[show edit update destroy close reopen move]

  def index
    params[:q] ||= {}
    params[:q][:closed_eq] ||= "0" unless params[:q].key?(:closed_eq)
    @q = policy_scope(Question).ransack(params[:q])
    @q.sorts = "created_at desc" if @q.sorts.empty?
    @questions = @q.result(distinct: true).includes(:team, :person, :replies).page(params[:page])
  end

  def show
    @voted_reply = @question.voted_reply_for(current_user.person)
    @promoted_replies = @question.promoted_replies(limit: 3)
    @top_level_replies = @question.replies.top_level.order(created_at: :asc)
    @reply = Reply.new
  end

  def new
    @question = authorize Question.new
  end

  def edit
  end

  def create
    @question = authorize Question.new(question_params)
    @question.person = current_user.person

    if @question.save
      redirect_to @question, notice: "Question was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question, notice: "Question was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy!
    redirect_to questions_url, notice: "Question was successfully destroyed.", status: :see_other
  end

  def close
    authorize @question, :close?
    @question.update!(closed: true)
    redirect_to @question, notice: "Question closed.", status: :see_other
  end

  def reopen
    authorize @question, :reopen?
    @question.update!(closed: false)
    redirect_to @question, notice: "Question reopened.", status: :see_other
  end

  def move
    authorize @question, :move?
    team = Team.find(params[:team_id])
    @question.update!(team: team)
    redirect_to @question, notice: "Question moved to #{team.name}.", status: :see_other
  end

  private

  def set_question
    @question = authorize policy_scope(Question).find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :content, :team_id)
  end
end
