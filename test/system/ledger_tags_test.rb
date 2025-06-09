require "application_system_test_case"

class LedgerTagsTest < ApplicationSystemTestCase
  setup do
    @ledger_tag = ledger_tags(:one)
  end

  test "visiting the index" do
    visit ledger_tags_url
    assert_selector "h1", text: "Ledger tags"
  end

  test "should create ledger tag" do
    visit ledger_tags_url
    click_on "New ledger tag"

    fill_in "Name", with: @ledger_tag.name
    click_on "Create Ledger tag"

    assert_text "Ledger tag was successfully created"
    click_on "Back"
  end

  test "should update Ledger tag" do
    visit ledger_tag_url(@ledger_tag)
    click_on "Edit this ledger tag", match: :first

    fill_in "Name", with: @ledger_tag.name
    click_on "Update Ledger tag"

    assert_text "Ledger tag was successfully updated"
    click_on "Back"
  end

  test "should destroy Ledger tag" do
    visit ledger_tag_url(@ledger_tag)
    click_on "Destroy this ledger tag", match: :first

    assert_text "Ledger tag was successfully destroyed"
  end
end
