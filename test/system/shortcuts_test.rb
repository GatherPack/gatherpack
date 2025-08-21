require "application_system_test_case"

class ShortcutsTest < ApplicationSystemTestCase
  setup do
    @shortcut = shortcuts(:one)
  end

  test "visiting the index" do
    visit shortcuts_url
    assert_selector "h1", text: "Shortcuts"
  end

  test "should create shortcut" do
    visit shortcuts_url
    click_on "New shortcut"

    fill_in "Color", with: @shortcut.color
    fill_in "Icon", with: @shortcut.icon
    fill_in "Name", with: @shortcut.name
    fill_in "Target", with: @shortcut.target
    fill_in "Team", with: @shortcut.team_id
    click_on "Create Shortcut"

    assert_text "Shortcut was successfully created"
    click_on "Back"
  end

  test "should update Shortcut" do
    visit shortcut_url(@shortcut)
    click_on "Edit this shortcut", match: :first

    fill_in "Color", with: @shortcut.color
    fill_in "Icon", with: @shortcut.icon
    fill_in "Name", with: @shortcut.name
    fill_in "Target", with: @shortcut.target
    fill_in "Team", with: @shortcut.team_id
    click_on "Update Shortcut"

    assert_text "Shortcut was successfully updated"
    click_on "Back"
  end

  test "should destroy Shortcut" do
    visit shortcut_url(@shortcut)
    click_on "Destroy this shortcut", match: :first

    assert_text "Shortcut was successfully destroyed"
  end
end
