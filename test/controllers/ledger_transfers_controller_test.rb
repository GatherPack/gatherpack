require "test_helper"

class LedgerTransfersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ledger_transfer = ledger_transfers(:one)
  end

  test "should get index" do
    get ledger_transfers_url
    assert_response :success
  end

  test "should get new" do
    get new_ledger_transfer_url
    assert_response :success
  end

  test "should create ledger_transfer" do
    assert_difference("LedgerTransfer.count") do
      post ledger_transfers_url, params: { ledger_transfer: { creator_id: @ledger_transfer.creator_id, creator_type: @ledger_transfer.creator_type, from_ledger_id: @ledger_transfer.from_ledger_id, to_ledger_id: @ledger_transfer.to_ledger_id } }
    end

    assert_redirected_to ledger_transfer_url(LedgerTransfer.last)
  end

  test "should show ledger_transfer" do
    get ledger_transfer_url(@ledger_transfer)
    assert_response :success
  end

  test "should get edit" do
    get edit_ledger_transfer_url(@ledger_transfer)
    assert_response :success
  end

  test "should update ledger_transfer" do
    patch ledger_transfer_url(@ledger_transfer), params: { ledger_transfer: { creator_id: @ledger_transfer.creator_id, creator_type: @ledger_transfer.creator_type, from_ledger_id: @ledger_transfer.from_ledger_id, to_ledger_id: @ledger_transfer.to_ledger_id } }
    assert_redirected_to ledger_transfer_url(@ledger_transfer)
  end

  test "should destroy ledger_transfer" do
    assert_difference("LedgerTransfer.count", -1) do
      delete ledger_transfer_url(@ledger_transfer)
    end

    assert_redirected_to ledger_transfers_url
  end
end
