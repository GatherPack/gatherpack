class Gateway::SmtpSendingGateway < Gateway
  Gateway.register(self, :email_sending)
  store_accessor :configuration, :host
  store_accessor :configuration, :port
  store_accessor :configuration, :username
  store_accessor :configuration, :password
  store_accessor :configuration, :sender
  store_accessor :configuration, :authentication

  def fields
    [ :host, :port, :username, :password, :sender, :authentication ]
  end

  def identifier_icon
    "envelopes-bulk"
  end

  def send_later(address, subject, body)
    address = [ address ].flatten
    address.each do |a|
      SendEmailJob.perform_later(self, a, subject, body)
    end
  end

  def send_message(address, subject, body)
    mail = Mail.new do
      from    sender
      to      address
      subject subject
      html_part do
        content_type "text/html; charset=UTF-8"
        body body
      end
    end

    smtp_options = {
      address:              host,
      port:                 (port || 587).to_i,
      enable_starttls_auto: true,
      user_name:            username.presence,
      password:             password.presence,
      authentication:       (authentication.presence || "plain").to_sym
    }

    smtp_options.delete(:user_name) if username.blank?
    smtp_options.delete(:password) if password.blank?
    smtp_options.delete(:authentication) if username.blank?

    mail.deliver_net_smtp(smtp_options)
  end
end
