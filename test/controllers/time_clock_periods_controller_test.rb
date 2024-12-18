require "test_helper"

class TimeClockPeriodsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @time_clock_period = time_clock_periods(:one)
  end

  test "should get index" do
    get time_clock_periods_url
    assert_response :success
  end

  test "should get new" do
    get new_time_clock_period_url
    assert_response :success
  end

  test "should create time_clock_period" do
    assert_difference("TimeClockPeriod.count") do
      post time_clock_periods_url, params: { time_clock_period: { end_time: @time_clock_period.end_time, name: @time_clock_period.name, permission: @time_clock_period.permission, start_time: @time_clock_period.start_time, team_id: @time_clock_period.team_id } }
    end

    assert_redirected_to time_clock_period_url(TimeClockPeriod.last)
  end

  test "should show time_clock_period" do
    get time_clock_period_url(@time_clock_period)
    assert_response :success
  end

  test "should get edit" do
    get edit_time_clock_period_url(@time_clock_period)
    assert_response :success
  end

  test "should update time_clock_period" do
    patch time_clock_period_url(@time_clock_period), params: { time_clock_period: { end_time: @time_clock_period.end_time, name: @time_clock_period.name, permission: @time_clock_period.permission, start_time: @time_clock_period.start_time, team_id: @time_clock_period.team_id } }
    assert_redirected_to time_clock_period_url(@time_clock_period)
  end

  test "should destroy time_clock_period" do
    assert_difference("TimeClockPeriod.count", -1) do
      delete time_clock_period_url(@time_clock_period)
    end

    assert_redirected_to time_clock_periods_url
  end
end
