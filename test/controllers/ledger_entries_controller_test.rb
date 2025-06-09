require "test_helper"

class LedgerEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ledger_entry = ledger_entries(:one)
  end

  test "should get index" do
    get ledger_entries_url
    assert_response :success
  end

  test "should get new" do
    get new_ledger_entry_url
    assert_response :success
  end

  test "should create ledger_entry" do
    assert_difference("LedgerEntry.count") do
      post ledger_entries_url, params: { ledger_entry: { amount_cents: @ledger_entry.amount_cents, approved: @ledger_entry.approved, comment: @ledger_entry.comment, created_by_id: @ledger_entry.created_by_id, created_by_type: @ledger_entry.created_by_type, ledger_id: @ledger_entry.ledger_id } }
    end

    assert_redirected_to ledger_entry_url(LedgerEntry.last)
  end

  test "should show ledger_entry" do
    get ledger_entry_url(@ledger_entry)
    assert_response :success
  end

  test "should get edit" do
    get edit_ledger_entry_url(@ledger_entry)
    assert_response :success
  end

  test "should update ledger_entry" do
    patch ledger_entry_url(@ledger_entry), params: { ledger_entry: { amount_cents: @ledger_entry.amount_cents, approved: @ledger_entry.approved, comment: @ledger_entry.comment, created_by_id: @ledger_entry.created_by_id, created_by_type: @ledger_entry.created_by_type, ledger_id: @ledger_entry.ledger_id } }
    assert_redirected_to ledger_entry_url(@ledger_entry)
  end

  test "should destroy ledger_entry" do
    assert_difference("LedgerEntry.count", -1) do
      delete ledger_entry_url(@ledger_entry)
    end

    assert_redirected_to ledger_entries_url
  end
end
