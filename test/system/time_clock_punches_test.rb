require "application_system_test_case"

class TimeClockPunchesTest < ApplicationSystemTestCase
  setup do
    @time_clock_punch = time_clock_punches(:one)
  end

  test "visiting the index" do
    visit time_clock_punches_url
    assert_selector "h1", text: "Time clock punches"
  end

  test "should create time clock punch" do
    visit time_clock_punches_url
    click_on "New time clock punch"

    fill_in "End time", with: @time_clock_punch.end_time
    fill_in "Person", with: @time_clock_punch.person_id
    fill_in "Start time", with: @time_clock_punch.start_time
    fill_in "Time clock period", with: @time_clock_punch.time_clock_period_id
    click_on "Create Time clock punch"

    assert_text "Time clock punch was successfully created"
    click_on "Back"
  end

  test "should update Time clock punch" do
    visit time_clock_punch_url(@time_clock_punch)
    click_on "Edit this time clock punch", match: :first

    fill_in "End time", with: @time_clock_punch.end_time.to_s
    fill_in "Person", with: @time_clock_punch.person_id
    fill_in "Start time", with: @time_clock_punch.start_time.to_s
    fill_in "Time clock period", with: @time_clock_punch.time_clock_period_id
    click_on "Update Time clock punch"

    assert_text "Time clock punch was successfully updated"
    click_on "Back"
  end

  test "should destroy Time clock punch" do
    visit time_clock_punch_url(@time_clock_punch)
    click_on "Destroy this time clock punch", match: :first

    assert_text "Time clock punch was successfully destroyed"
  end
end
