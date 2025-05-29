require "test_helper"

class LedgerEntryLinksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ledger_entry_link = ledger_entry_links(:one)
  end

  test "should get index" do
    get ledger_entry_links_url
    assert_response :success
  end

  test "should get new" do
    get new_ledger_entry_link_url
    assert_response :success
  end

  test "should create ledger_entry_link" do
    assert_difference("LedgerEntryLink.count") do
      post ledger_entry_links_url, params: { ledger_entry_link: {} }
    end

    assert_redirected_to ledger_entry_link_url(LedgerEntryLink.last)
  end

  test "should show ledger_entry_link" do
    get ledger_entry_link_url(@ledger_entry_link)
    assert_response :success
  end

  test "should get edit" do
    get edit_ledger_entry_link_url(@ledger_entry_link)
    assert_response :success
  end

  test "should update ledger_entry_link" do
    patch ledger_entry_link_url(@ledger_entry_link), params: { ledger_entry_link: {} }
    assert_redirected_to ledger_entry_link_url(@ledger_entry_link)
  end

  test "should destroy ledger_entry_link" do
    assert_difference("LedgerEntryLink.count", -1) do
      delete ledger_entry_link_url(@ledger_entry_link)
    end

    assert_redirected_to ledger_entry_links_url
  end
end
