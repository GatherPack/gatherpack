class BudgetPeriodsController < InternalController
  before_action :set_budget_period, only: %i[ show edit update destroy ]

  # GET /budget_periods
  def index
    @q = policy_scope(BudgetPeriod).ransack(params[:q])
    @budget_periods = @q.result(distinct: true).page(params[:page])
  end

  # GET /budget_periods/1
  def show
  end

  # GET /budget_periods/new
  def new
    @budget_period = authorize BudgetPeriod.new
  end

  # GET /budget_periods/1/edit
  def edit
  end

  # POST /budget_periods
  def create
    @budget_period = authorize BudgetPeriod.new(budget_period_params)

    if @budget_period.save
      redirect_to @budget_period, notice: "Budget period was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /budget_periods/1
  def update
    if @budget_period.update(budget_period_params)
      redirect_to @budget_period, notice: "Budget period was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /budget_periods/1
  def destroy
    @budget_period.destroy!
    redirect_to budget_periods_url, notice: "Budget period was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_budget_period
      @budget_period = authorize policy_scope(BudgetPeriod).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def budget_period_params
      params.require(:budget_period).permit(:team_id, :name, :starts_at, :ends_at)
    end
end
