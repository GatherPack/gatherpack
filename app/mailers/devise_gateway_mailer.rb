class DeviseGatewayMailer
  # Helper to render the Devise mailer templates as HTML
  def self.render_template(template, assigns)
    ApplicationController.render(
      template: "devise/mailer/#{template}",
      assigns: assigns,
      layout: false
    )
  end

  def self.pick_gateway(user)
    Gateway[:email_sending]
  end

  DummyMail = Struct.new(:deliver_now, :deliver_later)

  def self.reset_password_instructions(record, token, opts = {})
    subject = opts[:subject] || "Reset password instructions"
    body = render_template("reset_password_instructions", { resource: record, token: token })
    gateway = pick_gateway(record)
    SendEmailJob.perform_later(gateway, record.email, subject, body)
    DummyMail.new(true, true)
  end

  def self.confirmation_instructions(record, token, opts = {})
    subject = opts[:subject] || "Confirmation instructions"
    body = render_template("confirmation_instructions", { resource: record, token: token })
    gateway = pick_gateway(record)
    SendEmailJob.perform_later(gateway, record.email, subject, body)
    DummyMail.new(true, true)
  end

  def self.unlock_instructions(record, token, opts = {})
    subject = opts[:subject] || "Unlock instructions"
    body = render_template("unlock_instructions", { resource: record, token: token })
    gateway = pick_gateway(record)
    SendEmailJob.perform_later(gateway, record.email, subject, body)
    DummyMail.new(true, true)
  end

  def self.email_changed(record, opts = {})
    subject = opts[:subject] || "Email changed"
    body = render_template("email_changed", { resource: record })
    gateway = pick_gateway(record)
    SendEmailJob.perform_later(gateway, record.email, subject, body)
    DummyMail.new(true, true)
  end

  def self.password_change(record, opts = {})
    subject = opts[:subject] || "Password changed"
    body = render_template("password_change", { resource: record })
    gateway = pick_gateway(record)
    SendEmailJob.perform_later(gateway, record.email, subject, body)
    DummyMail.new(true, true)
  end
end
