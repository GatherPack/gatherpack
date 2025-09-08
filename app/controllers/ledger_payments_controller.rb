class LedgerPaymentsController < InternalController
  def new
    @ledger_payment = LedgerPayment.new(ledger_payment_params)
    @ledger_payment.gateway_id ||= Gateway.registered(:payment).first&.id
  end

  def create
    @ledger_payment = LedgerPayment.new(ledger_payment_params)
    if @ledger_payment.valid?
      @ledger_entry = @ledger_payment.gateway.start_payment(@ledger_payment, current_user)
      redirect_to [@ledger_payment.ledger, @ledger_entry]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def ledger_payment_params
    if params[:ledger_payment].present?
      params.require(:ledger_payment).permit(:gateway_id, :amount, :remark, :ledger_id) 
    else
      { ledger_id: params[:ledger_id], amount: params[:amount], remark: params[:remark] }
    end
  end
end
