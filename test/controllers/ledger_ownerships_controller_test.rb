require "test_helper"

class LedgerOwnershipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ledger_ownership = ledger_ownerships(:one)
  end

  test "should get index" do
    get ledger_ownerships_url
    assert_response :success
  end

  test "should get new" do
    get new_ledger_ownership_url
    assert_response :success
  end

  test "should create ledger_ownership" do
    assert_difference("LedgerOwnership.count") do
      post ledger_ownerships_url, params: { ledger_ownership: { ledger_references: @ledger_ownership.ledger_references, owner_id: @ledger_ownership.owner_id, owner_type: @ledger_ownership.owner_type } }
    end

    assert_redirected_to ledger_ownership_url(LedgerOwnership.last)
  end

  test "should show ledger_ownership" do
    get ledger_ownership_url(@ledger_ownership)
    assert_response :success
  end

  test "should get edit" do
    get edit_ledger_ownership_url(@ledger_ownership)
    assert_response :success
  end

  test "should update ledger_ownership" do
    patch ledger_ownership_url(@ledger_ownership), params: { ledger_ownership: { ledger_references: @ledger_ownership.ledger_references, owner_id: @ledger_ownership.owner_id, owner_type: @ledger_ownership.owner_type } }
    assert_redirected_to ledger_ownership_url(@ledger_ownership)
  end

  test "should destroy ledger_ownership" do
    assert_difference("LedgerOwnership.count", -1) do
      delete ledger_ownership_url(@ledger_ownership)
    end

    assert_redirected_to ledger_ownerships_url
  end
end
