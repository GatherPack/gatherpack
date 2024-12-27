require "application_system_test_case"

class CheckinFieldsTest < ApplicationSystemTestCase
  setup do
    @checkin_field = checkin_fields(:one)
  end

  test "visiting the index" do
    visit checkin_fields_url
    assert_selector "h1", text: "Checkin fields"
  end

  test "should create checkin field" do
    visit checkin_fields_url
    click_on "New checkin field"

    fill_in "Event type", with: @checkin_field.event_type_id
    fill_in "Name", with: @checkin_field.name
    fill_in "Permission", with: @checkin_field.permission
    click_on "Create Checkin field"

    assert_text "Checkin field was successfully created"
    click_on "Back"
  end

  test "should update Checkin field" do
    visit checkin_field_url(@checkin_field)
    click_on "Edit this checkin field", match: :first

    fill_in "Event type", with: @checkin_field.event_type_id
    fill_in "Name", with: @checkin_field.name
    fill_in "Permission", with: @checkin_field.permission
    click_on "Update Checkin field"

    assert_text "Checkin field was successfully updated"
    click_on "Back"
  end

  test "should destroy Checkin field" do
    visit checkin_field_url(@checkin_field)
    click_on "Destroy this checkin field", match: :first

    assert_text "Checkin field was successfully destroyed"
  end
end
