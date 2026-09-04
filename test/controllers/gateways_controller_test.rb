require "test_helper"

class GatewaysControllerTest < ActionDispatch::IntegrationTest
  test "webhook only forwards the headers the gateway class declares" do
    gateway = gateway_stripe_gateways(:with_secret)

    assert_enqueued_with(job: ProcessGatewayWebhookJob) do
      post webhook_gateway_url(gateway), params: "{}", headers: {
        "HTTP_STRIPE_SIGNATURE" => "t=123,v1=abc",
        "HTTP_X_FORWARDED_FOR" => "1.2.3.4",
        "HTTP_COOKIE" => "session=super-secret"
      }
    end

    headers = enqueued_jobs.last[:args][2].except("_aj_symbol_keys")

    assert_equal [ "HTTP_STRIPE_SIGNATURE" ], headers.keys
    assert_equal "t=123,v1=abc", headers["HTTP_STRIPE_SIGNATURE"]
  end
end
