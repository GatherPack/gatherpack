require "test_helper"

class CheckinFieldsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @checkin_field = checkin_fields(:one)
  end

  test "should get index" do
    get checkin_fields_url
    assert_response :success
  end

  test "should get new" do
    get new_checkin_field_url
    assert_response :success
  end

  test "should create checkin_field" do
    assert_difference("CheckinField.count") do
      post checkin_fields_url, params: { checkin_field: { event_type_id: @checkin_field.event_type_id, name: @checkin_field.name, permission: @checkin_field.permission } }
    end

    assert_redirected_to checkin_field_url(CheckinField.last)
  end

  test "should show checkin_field" do
    get checkin_field_url(@checkin_field)
    assert_response :success
  end

  test "should get edit" do
    get edit_checkin_field_url(@checkin_field)
    assert_response :success
  end

  test "should update checkin_field" do
    patch checkin_field_url(@checkin_field), params: { checkin_field: { event_type_id: @checkin_field.event_type_id, name: @checkin_field.name, permission: @checkin_field.permission } }
    assert_redirected_to checkin_field_url(@checkin_field)
  end

  test "should destroy checkin_field" do
    assert_difference("CheckinField.count", -1) do
      delete checkin_field_url(@checkin_field)
    end

    assert_redirected_to checkin_fields_url
  end
end
