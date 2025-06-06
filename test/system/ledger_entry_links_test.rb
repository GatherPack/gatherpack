require "application_system_test_case"

class LedgerEntryLinksTest < ApplicationSystemTestCase
  setup do
    @ledger_entry_link = ledger_entry_links(:one)
  end

  test "visiting the index" do
    visit ledger_entry_links_url
    assert_selector "h1", text: "Ledger entry links"
  end

  test "should create ledger entry link" do
    visit ledger_entry_links_url
    click_on "New ledger entry link"

    click_on "Create Ledger entry link"

    assert_text "Ledger entry link was successfully created"
    click_on "Back"
  end

  test "should update Ledger entry link" do
    visit ledger_entry_link_url(@ledger_entry_link)
    click_on "Edit this ledger entry link", match: :first

    click_on "Update Ledger entry link"

    assert_text "Ledger entry link was successfully updated"
    click_on "Back"
  end

  test "should destroy Ledger entry link" do
    visit ledger_entry_link_url(@ledger_entry_link)
    click_on "Destroy this ledger entry link", match: :first

    assert_text "Ledger entry link was successfully destroyed"
  end
end
