class LedgerPaymentsController < InternalController
  def new
    @ledger_payment = LedgerPayment.new(ledger_id: params[:ledger_id])
  end

  def create
    @ledger_payment = LedgerPayment.new(ledger_payment_params)
    @ledger_entry = @ledger_payment.gateway.start_payment(@ledger_payment, current_user)
    redirect_to [@ledger_payment.ledger, @ledger_entry]
  end

  def ledger_payment_params
    params.require(:ledger_payment).permit(:gateway_id, :amount, :remark, :ledger_id)
  end
end
