require "test_helper"

class CheckinFieldResponsesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @checkin_field_response = checkin_field_responses(:one)
  end

  test "should get index" do
    get checkin_field_responses_url
    assert_response :success
  end

  test "should get new" do
    get new_checkin_field_response_url
    assert_response :success
  end

  test "should create checkin_field_response" do
    assert_difference("CheckinFieldResponse.count") do
      post checkin_field_responses_url, params: { checkin_field_response: { checkin_field_id: @checkin_field_response.checkin_field_id, checkin_id: @checkin_field_response.checkin_id, response: @checkin_field_response.response } }
    end

    assert_redirected_to checkin_field_response_url(CheckinFieldResponse.last)
  end

  test "should show checkin_field_response" do
    get checkin_field_response_url(@checkin_field_response)
    assert_response :success
  end

  test "should get edit" do
    get edit_checkin_field_response_url(@checkin_field_response)
    assert_response :success
  end

  test "should update checkin_field_response" do
    patch checkin_field_response_url(@checkin_field_response), params: { checkin_field_response: { checkin_field_id: @checkin_field_response.checkin_field_id, checkin_id: @checkin_field_response.checkin_id, response: @checkin_field_response.response } }
    assert_redirected_to checkin_field_response_url(@checkin_field_response)
  end

  test "should destroy checkin_field_response" do
    assert_difference("CheckinFieldResponse.count", -1) do
      delete checkin_field_response_url(@checkin_field_response)
    end

    assert_redirected_to checkin_field_responses_url
  end
end
