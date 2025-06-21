require "test_helper"

class LedgerPaymentsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get ledger_payments_new_url
    assert_response :success
  end

  test "should get create" do
    get ledger_payments_create_url
    assert_response :success
  end
end
