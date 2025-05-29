class LedgerTransfersController < InternalController
  # GET /ledger_transfers/new
  def new
    @ledger_transfer = authorize LedgerTransfer.new
  end

  # POST /ledger_transfers
  def create
    @ledger_transfer = authorize LedgerTransfer.new(ledger_transfer_params)
    @ledger_transfer.creator = current_user

    if @ledger_transfer.create
      redirect_to @ledger_transfer.to_ledger, notice: "Ledger transfer was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def ledger_transfer_params
      params.require(:ledger_transfer).permit(:from_ledger_id, :to_ledger_id, :amount)
    end
end
