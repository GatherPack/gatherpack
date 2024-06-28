require "application_system_test_case"

class BadgeTypesTest < ApplicationSystemTestCase
  setup do
    @badge_type = badge_types(:one)
  end

  test "visiting the index" do
    visit badge_types_url
    assert_selector "h1", text: "Badge types"
  end

  test "should create badge type" do
    visit badge_types_url
    click_on "New badge type"

    fill_in "Name", with: @badge_type.name
    click_on "Create Badge type"

    assert_text "Badge type was successfully created"
    click_on "Back"
  end

  test "should update Badge type" do
    visit badge_type_url(@badge_type)
    click_on "Edit this badge type", match: :first

    fill_in "Name", with: @badge_type.name
    click_on "Update Badge type"

    assert_text "Badge type was successfully updated"
    click_on "Back"
  end

  test "should destroy Badge type" do
    visit badge_type_url(@badge_type)
    click_on "Destroy this badge type", match: :first

    assert_text "Badge type was successfully destroyed"
  end
end
