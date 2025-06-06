class LedgerPayment
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :gateway_id, :string
  attribute :ledger_id, :string
  attribute :amount, :decimal
  attribute :remark, :string

  def gateway
    Gateway.find(gateway_id)
  end

  def ledger
    Ledger.find(ledger_id)
  end
end