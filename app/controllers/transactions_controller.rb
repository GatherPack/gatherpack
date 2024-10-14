class TransactionsController < ApplicationController
  def index
    @transaction = authorize Transaction.new
  end

  def create
    @transaction = authorize Transaction.new(transaction_params)
    @transaction.created_by = current_user.person

    if @transaction.save
      redirect_to params[:redirect_target] || @transaction.account, notice: 'Transaction successfully posted'
    else
      redirect_to params[:redirect_target] || Account.find(params[:transaction][:account_id]), error: 'Transaction failed to post'
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:comment, :amount, :account_id)
  end
end
