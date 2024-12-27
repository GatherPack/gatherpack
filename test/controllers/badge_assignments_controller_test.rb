require "test_helper"

class BadgeAssignmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get badge_assignments_index_url
    assert_response :success
  end
end
