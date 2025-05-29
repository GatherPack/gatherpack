class LedgersController < InternalController
  before_action :set_ledger, only: %i[ show edit update destroy ]

  # GET /ledgers
  def index
    @q = policy_scope(Ledger).ransack(params[:q])
    @ledgers = @q.result(distinct: true).page(params[:page])
  end

  # GET /ledgers/1
  def show
  end

  # GET /ledgers/new
  def new
    @ledger = authorize Ledger.new
  end

  # GET /ledgers/1/edit
  def edit
  end

  # POST /ledgers
  def create
    @ledger = authorize Ledger.new(ledger_params)

    if @ledger.save
      redirect_to @ledger, notice: "Ledger was successfully created."
    else
      raise "ded"
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ledgers/1
  def update
    if @ledger.update(ledger_params)
      redirect_to @ledger, notice: "Ledger was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /ledgers/1
  def destroy
    @ledger.destroy!
    redirect_to ledgers_url, notice: "Ledger was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ledger
      @ledger = authorize policy_scope(Ledger).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ledger_params
      params.require(:ledger).permit(:name, :team_id)
    end
end
