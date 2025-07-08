class LedgerOwnershipsController < InternalController
  before_action :set_ledger
  before_action :set_ledger_ownership, only: %i[ show edit update destroy ]

  # GET /ledger_ownerships
  def index
    @q = policy_scope(LedgerOwnership).ransack(params[:q])
    @ledger_ownerships = @q.result(distinct: true).page(params[:page])
  end

  # GET /ledger_ownerships/1
  def show
  end

  # GET /ledger_ownerships/new
  def new
    @ledger_ownership = authorize LedgerOwnership.new
  end

  # GET /ledger_ownerships/1/edit
  def edit
    redirect_to ledger_ownership_path(@ledger, @ledger_ownership)
  end

  # POST /ledger_ownerships
  def create
    @ledger_ownership = authorize LedgerOwnership.new(ledger_ownership_params)

    if @ledger_ownership.save
      redirect_to ledger_ownership_path(@ledger, @ledger_ownership), notice: "Ledger ownership was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ledger_ownerships/1
  def update
    if @ledger_ownership.update(ledger_ownership_params)
      redirect_to @ledger_ownership, notice: "Ledger ownership was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /ledger_ownerships/1
  def destroy
    @ledger_ownership.destroy!
    redirect_to ledger_ownerships_url, notice: "Ledger ownership was successfully destroyed.", status: :see_other
  end

  private
    def set_ledger
      @ledger = policy_scope(Ledger).find(params[:ledger_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_ledger_ownership
      @ledger_ownership = policy_scope(LedgerOwnership).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ledger_ownership_params
      params.require(:ledger_ownership).permit(:ledger_id, :owner_nid)
    end
end
