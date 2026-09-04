require "test_helper"

class ProcessGatewayWebhookJobTest < ActiveJob::TestCase
  class RecordingGateway
    attr_reader :received_payload, :received_headers

    def handle_webhook(payload, headers)
      @received_payload = payload
      @received_headers = headers
    end
  end

  test "perform passes the payload and headers hash through to the gateway unchanged" do
    payload = '{"type":"email.bounced"}'
    headers = { "HTTP_SVIX_ID" => "msg_123", "HTTP_SVIX_TIMESTAMP" => "1700000000", "HTTP_SVIX_SIGNATURE" => "v1,abc" }
    gateway = RecordingGateway.new

    ProcessGatewayWebhookJob.perform_now(gateway, payload, headers)

    assert_equal payload, gateway.received_payload
    assert_equal headers, gateway.received_headers
  end
end
