require "test_helper"

class PersonActivityControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get person_activity_index_url
    assert_response :success
  end
end
