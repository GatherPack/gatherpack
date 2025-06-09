require "test_helper"

class LedgersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ledger = ledgers(:one)
  end

  test "should get index" do
    get ledgers_url
    assert_response :success
  end

  test "should get new" do
    get new_ledger_url
    assert_response :success
  end

  test "should create ledger" do
    assert_difference("Ledger.count") do
      post ledgers_url, params: { ledger: { balance_cents: @ledger.balance_cents, name: @ledger.name, team_id: @ledger.team_id } }
    end

    assert_redirected_to ledger_url(Ledger.last)
  end

  test "should show ledger" do
    get ledger_url(@ledger)
    assert_response :success
  end

  test "should get edit" do
    get edit_ledger_url(@ledger)
    assert_response :success
  end

  test "should update ledger" do
    patch ledger_url(@ledger), params: { ledger: { balance_cents: @ledger.balance_cents, name: @ledger.name, team_id: @ledger.team_id } }
    assert_redirected_to ledger_url(@ledger)
  end

  test "should destroy ledger" do
    assert_difference("Ledger.count", -1) do
      delete ledger_url(@ledger)
    end

    assert_redirected_to ledgers_url
  end
end
