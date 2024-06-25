require "application_system_test_case"

class EventTypesTest < ApplicationSystemTestCase
  setup do
    @event_type = event_types(:one)
  end

  test "visiting the index" do
    visit event_types_url
    assert_selector "h1", text: "Event types"
  end

  test "should create event type" do
    visit event_types_url
    click_on "New event type"

    fill_in "Name", with: @event_type.name
    click_on "Create Event type"

    assert_text "Event type was successfully created"
    click_on "Back"
  end

  test "should update Event type" do
    visit event_type_url(@event_type)
    click_on "Edit this event type", match: :first

    fill_in "Name", with: @event_type.name
    click_on "Update Event type"

    assert_text "Event type was successfully updated"
    click_on "Back"
  end

  test "should destroy Event type" do
    visit event_type_url(@event_type)
    click_on "Destroy this event type", match: :first

    assert_text "Event type was successfully destroyed"
  end
end
