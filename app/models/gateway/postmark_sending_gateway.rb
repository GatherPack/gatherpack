class Gateway::PostmarkSendingGateway < Gateway
  Gateway.register(self, :email_sending)
  store_accessor :configuration, :api_token
  store_accessor :configuration, :sender

  def fields
    [ :api_token, :sender ]
  end

  def identifier_icon
    "envelopes-bulk"
  end

  def send_later(sender, address, subject, body)
    address = [ address ].flatten
    address.each do |a|
      SendEmailJob.perform_later(a, subject, body)
    end
  end

  def send_message(sender, address, subject, body)
    client = Postmark::ApiClient.new(api_token)

    client.deliver(
      from: sender,
      to: address,
      subject: subject,
      html_body: body,
      track_opens: false,
      message_stream: "outbound"
    )
  end

  def handle_webhook(body, signature)
    payload = JSON.parse(body)

    case payload["RecordType"]
    when "SpamComplaint"
      # disable all notifications for this gateway for this user
    when "Bounce"
      # disable all notifications for this gateway for this user
    when "SubscriptionChange"
      if payload["SuppressSending"]
        # disable all notifications for this gateway for this user
      end
    end
  end

  def finish_setup
    client = Postmark::ApiClient.new(api_token)
    client.create_webhook(
    {
      url: Rails.application.routes.url_helpers.webhook_gateway_url(self),
      message_stream: "outbound",
      triggers: {
         Bounce: { Enabled: true, IncludeContent: false },
         SpamComplaint: { Enabled: true, IncludeContent: false },
         SubscriptionChange: { Enabled: true }
      }
    })
  end
end
