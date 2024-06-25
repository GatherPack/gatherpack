require "test_helper"

class EventTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event_type = event_types(:one)
  end

  test "should get index" do
    get event_types_url
    assert_response :success
  end

  test "should get new" do
    get new_event_type_url
    assert_response :success
  end

  test "should create event_type" do
    assert_difference("EventType.count") do
      post event_types_url, params: { event_type: { name: @event_type.name } }
    end

    assert_redirected_to event_type_url(EventType.last)
  end

  test "should show event_type" do
    get event_type_url(@event_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_event_type_url(@event_type)
    assert_response :success
  end

  test "should update event_type" do
    patch event_type_url(@event_type), params: { event_type: { name: @event_type.name } }
    assert_redirected_to event_type_url(@event_type)
  end

  test "should destroy event_type" do
    assert_difference("EventType.count", -1) do
      delete event_type_url(@event_type)
    end

    assert_redirected_to event_types_url
  end
end
