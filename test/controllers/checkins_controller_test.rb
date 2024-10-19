require "test_helper"

class CheckinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @checkin = checkins(:one)
  end

  test "should get index" do
    get checkins_url
    assert_response :success
  end

  test "should get new" do
    get new_checkin_url
    assert_response :success
  end

  test "should create checkin" do
    assert_difference("Checkin.count") do
      post checkins_url, params: { checkin: { event_id: @checkin.event_id, notes: @checkin.notes, person_id: @checkin.person_id } }
    end

    assert_redirected_to checkin_url(Checkin.last)
  end

  test "should show checkin" do
    get checkin_url(@checkin)
    assert_response :success
  end

  test "should get edit" do
    get edit_checkin_url(@checkin)
    assert_response :success
  end

  test "should update checkin" do
    patch checkin_url(@checkin), params: { checkin: { event_id: @checkin.event_id, notes: @checkin.notes, person_id: @checkin.person_id } }
    assert_redirected_to checkin_url(@checkin)
  end

  test "should destroy checkin" do
    assert_difference("Checkin.count", -1) do
      delete checkin_url(@checkin)
    end

    assert_redirected_to checkins_url
  end
end
