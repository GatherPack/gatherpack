require "application_system_test_case"

class LedgerOwnershipsTest < ApplicationSystemTestCase
  setup do
    @ledger_ownership = ledger_ownerships(:one)
  end

  test "visiting the index" do
    visit ledger_ownerships_url
    assert_selector "h1", text: "Ledger ownerships"
  end

  test "should create ledger ownership" do
    visit ledger_ownerships_url
    click_on "New ledger ownership"

    fill_in "Ledger references", with: @ledger_ownership.ledger_references
    fill_in "Owner", with: @ledger_ownership.owner_id
    fill_in "Owner type", with: @ledger_ownership.owner_type
    click_on "Create Ledger ownership"

    assert_text "Ledger ownership was successfully created"
    click_on "Back"
  end

  test "should update Ledger ownership" do
    visit ledger_ownership_url(@ledger_ownership)
    click_on "Edit this ledger ownership", match: :first

    fill_in "Ledger references", with: @ledger_ownership.ledger_references
    fill_in "Owner", with: @ledger_ownership.owner_id
    fill_in "Owner type", with: @ledger_ownership.owner_type
    click_on "Update Ledger ownership"

    assert_text "Ledger ownership was successfully updated"
    click_on "Back"
  end

  test "should destroy Ledger ownership" do
    visit ledger_ownership_url(@ledger_ownership)
    click_on "Destroy this ledger ownership", match: :first

    assert_text "Ledger ownership was successfully destroyed"
  end
end
