require "application_system_test_case"

class LedgersTest < ApplicationSystemTestCase
  setup do
    @ledger = ledgers(:one)
  end

  test "visiting the index" do
    visit ledgers_url
    assert_selector "h1", text: "Ledgers"
  end

  test "should create ledger" do
    visit ledgers_url
    click_on "New ledger"

    fill_in "Balance cents", with: @ledger.balance_cents
    fill_in "Name", with: @ledger.name
    fill_in "Team", with: @ledger.team_id
    click_on "Create Ledger"

    assert_text "Ledger was successfully created"
    click_on "Back"
  end

  test "should update Ledger" do
    visit ledger_url(@ledger)
    click_on "Edit this ledger", match: :first

    fill_in "Balance cents", with: @ledger.balance_cents
    fill_in "Name", with: @ledger.name
    fill_in "Team", with: @ledger.team_id
    click_on "Update Ledger"

    assert_text "Ledger was successfully updated"
    click_on "Back"
  end

  test "should destroy Ledger" do
    visit ledger_url(@ledger)
    click_on "Destroy this ledger", match: :first

    assert_text "Ledger was successfully destroyed"
  end
end
