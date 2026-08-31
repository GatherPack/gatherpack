require "test_helper"

class Gateway::ResendSendingGatewayTest < ActiveSupport::TestCase
  setup do
    @secret = "whsec_#{Base64.strict_encode64("resend-test-signing-secret")}"
    @gateway = Gateway::ResendSendingGateway.new(secret: @secret)
    @payload = { type: "email.bounced", data: { email_id: "abc123" } }.to_json
  end

  def svix_headers_for(payload, secret)
    msg_id = "msg_test123"
    timestamp = Time.now.to_i.to_s
    signature = Svix::Webhook.new(secret).sign(msg_id, timestamp, payload)

    {
      "HTTP_SVIX_ID" => msg_id,
      "HTTP_SVIX_TIMESTAMP" => timestamp,
      "HTTP_SVIX_SIGNATURE" => signature
    }
  end

  test "webhook_headers returns the svix header names" do
    assert_equal [ "HTTP_SVIX_ID", "HTTP_SVIX_TIMESTAMP", "HTTP_SVIX_SIGNATURE" ], Gateway::ResendSendingGateway.webhook_headers
  end

  test "handle_webhook verifies and processes a valid payload" do
    headers = svix_headers_for(@payload, @secret)

    assert_nothing_raised do
      @gateway.handle_webhook(@payload, headers)
    end
  end

  test "handle_webhook raises on an invalid signature when secret is present" do
    headers = svix_headers_for(@payload, "whsec_#{Base64.strict_encode64("a-completely-different-secret")}")

    assert_raises(RuntimeError) do
      @gateway.handle_webhook(@payload, headers)
    end
  end

  test "handle_webhook skips verification when secret is blank" do
    gateway = Gateway::ResendSendingGateway.new(secret: nil)
    headers = { "HTTP_SVIX_ID" => nil, "HTTP_SVIX_TIMESTAMP" => nil, "HTTP_SVIX_SIGNATURE" => nil }

    assert_nothing_raised do
      gateway.handle_webhook(@payload, headers)
    end
  end

  test "send_message calls Resend::Emails.send with a single positional hash" do
    gateway = Gateway::ResendSendingGateway.new(api_token: "re_test", sender: "noreply@example.com")
    captured = nil

    original_send = Resend::Emails.method(:send)
    Resend::Emails.define_singleton_method(:send) do |params, options: {}|
      captured = params
    end

    begin
      assert_nothing_raised do
        gateway.send_message("someone@example.com", "Subject", "<p>Body</p>")
      end
    ensure
      Resend::Emails.define_singleton_method(:send, original_send)
    end

    assert_equal({ from: "noreply@example.com", to: "someone@example.com", subject: "Subject", html: "<p>Body</p>" }, captured)
  end

  test "finish_setup logs a warning and leaves secret blank when the API token lacks webhook permissions" do
    original_create = Resend::Webhooks.method(:create)
    Resend::Webhooks.define_singleton_method(:create) do |*|
      raise Resend::Error::InvalidRequestError.new("This API key is restricted to only send emails", 401)
    end

    begin
      gateway = Gateway::ResendSendingGateway.create!(name: "Resend", api_token: "re_restricted_token", sender: "noreply@example.com")

      assert_nothing_raised do
        gateway.finish_setup
      end
    ensure
      Resend::Webhooks.define_singleton_method(:create, original_create)
    end

    assert_nil gateway.secret
  end
end
