require "application_system_test_case"

class TimeClockPeriodsTest < ApplicationSystemTestCase
  setup do
    @time_clock_period = time_clock_periods(:one)
  end

  test "visiting the index" do
    visit time_clock_periods_url
    assert_selector "h1", text: "Time clock periods"
  end

  test "should create time clock period" do
    visit time_clock_periods_url
    click_on "New time clock period"

    fill_in "End time", with: @time_clock_period.end_time
    fill_in "Name", with: @time_clock_period.name
    fill_in "Permission", with: @time_clock_period.permission
    fill_in "Start time", with: @time_clock_period.start_time
    fill_in "Team", with: @time_clock_period.team_id
    click_on "Create Time clock period"

    assert_text "Time clock period was successfully created"
    click_on "Back"
  end

  test "should update Time clock period" do
    visit time_clock_period_url(@time_clock_period)
    click_on "Edit this time clock period", match: :first

    fill_in "End time", with: @time_clock_period.end_time.to_s
    fill_in "Name", with: @time_clock_period.name
    fill_in "Permission", with: @time_clock_period.permission
    fill_in "Start time", with: @time_clock_period.start_time.to_s
    fill_in "Team", with: @time_clock_period.team_id
    click_on "Update Time clock period"

    assert_text "Time clock period was successfully updated"
    click_on "Back"
  end

  test "should destroy Time clock period" do
    visit time_clock_period_url(@time_clock_period)
    click_on "Destroy this time clock period", match: :first

    assert_text "Time clock period was successfully destroyed"
  end
end
