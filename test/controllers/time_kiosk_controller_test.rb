require "test_helper"

class TimeKioskControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get time_kiosk_index_url
    assert_response :success
  end

  test "should get create" do
    get time_kiosk_create_url
    assert_response :success
  end
end
