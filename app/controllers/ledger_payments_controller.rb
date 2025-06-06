class LedgerPaymentsController < ApplicationController
  def new
    @ledger_payment = LedgerPayment.new(ledger_id: params[:ledger_id])
  end

  def create
    @ledger_payment = LedgerPayment.new(ledger_payment_params)
    raise 'ded'
  end

  def ledger_payment_params
    params.require(:ledger_payment).permit(:gateway_id, :amount, :ledger_id)
  end
end
