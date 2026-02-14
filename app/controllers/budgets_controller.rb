class BudgetsController < InternalController
  before_action :set_budget, only: %i[ show edit update destroy ]

  # GET /budgets
  def index
    @q = policy_scope(Budget).ransack(params[:q])
    @budgets = @q.result(distinct: true).page(params[:page])
  end

  # GET /budgets/1
  def show
  end

  # GET /budgets/new
  def new
    @budget = authorize Budget.new
  end

  # GET /budgets/1/edit
  def edit
  end

  # POST /budgets
  def create
    @budget = authorize Budget.new(budget_params)

    if @budget.save
      redirect_to @budget, notice: "Budget was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /budgets/1
  def update
    if @budget.update(budget_params)
      redirect_to @budget, notice: "Budget was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /budgets/1
  def destroy
    @budget.destroy!
    redirect_to budgets_url, notice: "Budget was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_budget
      @budget = authorize policy_scope(Budget).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def budget_params
      params.require(:budget).permit(:amount, :budget_period_id, ledger_tag_ids: [])
    end
end
