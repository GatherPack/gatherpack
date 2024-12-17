require "application_system_test_case"

class CheckinFieldResponsesTest < ApplicationSystemTestCase
  setup do
    @checkin_field_response = checkin_field_responses(:one)
  end

  test "visiting the index" do
    visit checkin_field_responses_url
    assert_selector "h1", text: "Checkin field responses"
  end

  test "should create checkin field response" do
    visit checkin_field_responses_url
    click_on "New checkin field response"

    fill_in "Checkin field", with: @checkin_field_response.checkin_field_id
    fill_in "Checkin", with: @checkin_field_response.checkin_id
    fill_in "Response", with: @checkin_field_response.response
    click_on "Create Checkin field response"

    assert_text "Checkin field response was successfully created"
    click_on "Back"
  end

  test "should update Checkin field response" do
    visit checkin_field_response_url(@checkin_field_response)
    click_on "Edit this checkin field response", match: :first

    fill_in "Checkin field", with: @checkin_field_response.checkin_field_id
    fill_in "Checkin", with: @checkin_field_response.checkin_id
    fill_in "Response", with: @checkin_field_response.response
    click_on "Update Checkin field response"

    assert_text "Checkin field response was successfully updated"
    click_on "Back"
  end

  test "should destroy Checkin field response" do
    visit checkin_field_response_url(@checkin_field_response)
    click_on "Destroy this checkin field response", match: :first

    assert_text "Checkin field response was successfully destroyed"
  end
end
