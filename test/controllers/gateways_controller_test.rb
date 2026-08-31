require "test_helper"

class GatewaysControllerTest < ActionDispatch::IntegrationTest
  def queue_adapter_for_test
    ActiveJob::QueueAdapters::TestAdapter.new
  end

  setup do
    @gateway = gateways(:one)
  end

  test "should get index" do
    get gateways_url
    assert_response :success
  end

  test "should get new" do
    get new_gateway_url
    assert_response :success
  end

  test "should create gateway" do
    assert_difference("Gateway.count") do
      post gateways_url, params: { gateway: { configuration: @gateway.configuration, name: @gateway.name, provides: @gateway.provides, type: @gateway.type } }
    end

    assert_redirected_to gateway_url(Gateway.last)
  end

  test "should show gateway" do
    get gateway_url(@gateway)
    assert_response :success
  end

  test "should get edit" do
    get edit_gateway_url(@gateway)
    assert_response :success
  end

  test "should update gateway" do
    patch gateway_url(@gateway), params: { gateway: { configuration: @gateway.configuration, name: @gateway.name, provides: @gateway.provides, type: @gateway.type } }
    assert_redirected_to gateway_url(@gateway)
  end

  test "should destroy gateway" do
    assert_difference("Gateway.count", -1) do
      delete gateway_url(@gateway)
    end

    assert_redirected_to gateways_url
  end

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
