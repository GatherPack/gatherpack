class Gateway::PostmarkReceivingGateway < Gateway
  Gateway.register(self, :email_receiving)
  store_accessor :configuration, :server_token

  def fields
    [ :server_token ]
  end

  def identifier_icon
    "envelope-open-text"
  end

  def handle_webhook(body, signature)
    payload = JSON.parse(body)
    (payload["ToFull"] + payload["CcFull"] + payload["BccFull"]).each do |recipient|
      if mb = Mailbox.where(address: recipient["Email"]).first
        MailboxMessage.create(mailbox: mb, from: payload["FromFull"]["Email"], subject: payload["Subject"], body: payload["HtmlBody"] || payload["TextBody"])
      end
    end
  end

  def finish_setup
    client = Postmark::ApiClient.new(api_token)
  end
end
