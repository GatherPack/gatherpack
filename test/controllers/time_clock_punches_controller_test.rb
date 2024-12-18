require "test_helper"

class TimeClockPunchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @time_clock_punch = time_clock_punches(:one)
  end

  test "should get index" do
    get time_clock_punches_url
    assert_response :success
  end

  test "should get new" do
    get new_time_clock_punch_url
    assert_response :success
  end

  test "should create time_clock_punch" do
    assert_difference("TimeClockPunch.count") do
      post time_clock_punches_url, params: { time_clock_punch: { end_time: @time_clock_punch.end_time, person_id: @time_clock_punch.person_id, start_time: @time_clock_punch.start_time, time_clock_period_id: @time_clock_punch.time_clock_period_id } }
    end

    assert_redirected_to time_clock_punch_url(TimeClockPunch.last)
  end

  test "should show time_clock_punch" do
    get time_clock_punch_url(@time_clock_punch)
    assert_response :success
  end

  test "should get edit" do
    get edit_time_clock_punch_url(@time_clock_punch)
    assert_response :success
  end

  test "should update time_clock_punch" do
    patch time_clock_punch_url(@time_clock_punch), params: { time_clock_punch: { end_time: @time_clock_punch.end_time, person_id: @time_clock_punch.person_id, start_time: @time_clock_punch.start_time, time_clock_period_id: @time_clock_punch.time_clock_period_id } }
    assert_redirected_to time_clock_punch_url(@time_clock_punch)
  end

  test "should destroy time_clock_punch" do
    assert_difference("TimeClockPunch.count", -1) do
      delete time_clock_punch_url(@time_clock_punch)
    end

    assert_redirected_to time_clock_punches_url
  end
end
