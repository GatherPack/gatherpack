class Gateway::StripeGateway < Gateway
  Gateway.register(self, :payment)
  store_accessor :configuration, :secret_key
  store_accessor :configuration, :public_key
  store_accessor :configuration, :test_mode

  def fields
    [ :public_key, :secret_key, :test_mode ]
  end

  def identifier_icon
    ["cc-stripe", "brands"]
  end

  def start_payment(ledger_payment, creator)
    ledger_entry = LedgerEntry.create(ledger: ledger_payment.ledger, amount: ledger_payment.amount, finalized: false, created_by: creator)
    cko = Stripe::Checkout::Session.create({
      line_items: [

      ],
      mode: 'payment',
      success_url: 'http://localhost:3000/'
    })
  end
end
