require "application_system_test_case"

class LedgerTransfersTest < ApplicationSystemTestCase
  setup do
    @ledger_transfer = ledger_transfers(:one)
  end

  test "visiting the index" do
    visit ledger_transfers_url
    assert_selector "h1", text: "Ledger transfers"
  end

  test "should create ledger transfer" do
    visit ledger_transfers_url
    click_on "New ledger transfer"

    fill_in "Creator", with: @ledger_transfer.creator_id
    fill_in "Creator type", with: @ledger_transfer.creator_type
    fill_in "From ledger", with: @ledger_transfer.from_ledger_id
    fill_in "To ledger", with: @ledger_transfer.to_ledger_id
    click_on "Create Ledger transfer"

    assert_text "Ledger transfer was successfully created"
    click_on "Back"
  end

  test "should update Ledger transfer" do
    visit ledger_transfer_url(@ledger_transfer)
    click_on "Edit this ledger transfer", match: :first

    fill_in "Creator", with: @ledger_transfer.creator_id
    fill_in "Creator type", with: @ledger_transfer.creator_type
    fill_in "From ledger", with: @ledger_transfer.from_ledger_id
    fill_in "To ledger", with: @ledger_transfer.to_ledger_id
    click_on "Update Ledger transfer"

    assert_text "Ledger transfer was successfully updated"
    click_on "Back"
  end

  test "should destroy Ledger transfer" do
    visit ledger_transfer_url(@ledger_transfer)
    click_on "Destroy this ledger transfer", match: :first

    assert_text "Ledger transfer was successfully destroyed"
  end
end
