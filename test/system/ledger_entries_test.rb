require "application_system_test_case"

class LedgerEntriesTest < ApplicationSystemTestCase
  setup do
    @ledger_entry = ledger_entries(:one)
  end

  test "visiting the index" do
    visit ledger_entries_url
    assert_selector "h1", text: "Ledger entries"
  end

  test "should create ledger entry" do
    visit ledger_entries_url
    click_on "New ledger entry"

    fill_in "Amount cents", with: @ledger_entry.amount_cents
    check "Approved" if @ledger_entry.approved
    fill_in "Comment", with: @ledger_entry.comment
    fill_in "Created by", with: @ledger_entry.created_by_id
    fill_in "Created by type", with: @ledger_entry.created_by_type
    fill_in "Ledger", with: @ledger_entry.ledger_id
    click_on "Create Ledger entry"

    assert_text "Ledger entry was successfully created"
    click_on "Back"
  end

  test "should update Ledger entry" do
    visit ledger_entry_url(@ledger_entry)
    click_on "Edit this ledger entry", match: :first

    fill_in "Amount cents", with: @ledger_entry.amount_cents
    check "Approved" if @ledger_entry.approved
    fill_in "Comment", with: @ledger_entry.comment
    fill_in "Created by", with: @ledger_entry.created_by_id
    fill_in "Created by type", with: @ledger_entry.created_by_type
    fill_in "Ledger", with: @ledger_entry.ledger_id
    click_on "Update Ledger entry"

    assert_text "Ledger entry was successfully updated"
    click_on "Back"
  end

  test "should destroy Ledger entry" do
    visit ledger_entry_url(@ledger_entry)
    click_on "Destroy this ledger entry", match: :first

    assert_text "Ledger entry was successfully destroyed"
  end
end
