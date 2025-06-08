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
    ledger_entry = LedgerEntry.create(ledger: ledger_payment.ledger, amount: ledger_payment.amount, finalized: false, created_by: creator, remark: "Paid via Stripe | #{ledger_payment.remark}")
    checkout = Stripe::Checkout::Session.create({
      line_items: [
        {
          price_data: {
            currency: 'usd',
            unit_amount: ledger_entry.amount_cents,
            product_data: {
              name: ledger_payment.remark
            }
          },
          quantity: 1,

        }
      ],
      mode: 'payment',
      success_url: Rails.application.routes.url_helpers.ledger_ledger_entry_url(ledger_entry.ledger, ledger_entry, host: 'http://localhost:3000')
    },
    {
      api_key: secret_key
    }
    )
    ledger_entry.update(metadata: { gateway_id: id, stripe_checkout_session: { id: checkout.id, url: checkout.url } })
    ledger_entry
  end

  def handle_webhook(payload, signature)
    event = Stripe::Event.construct_from(JSON.parse(payload))
    case event.type
    when "checkout.session.completed", "checkout.session.async_payment_succeeded"
      ledger_entry = LedgerEntry.where("metadata->'stripe_checkout_session'->>'id' = ?", event.data.object.id)
      ledger_entry.update(finalized: event.data.object.payment_status == "paid")
    end
  end
end
