require "test_helper"

class BadgeAssignmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @badge_assignment = badge_assignments(:one)
  end

  test "should get index" do
    get badge_assignments_url
    assert_response :success
  end

  test "should get new" do
    get new_badge_assignment_url
    assert_response :success
  end

  test "should create badge_assignment" do
    assert_difference("BadgeAssignment.count") do
      post badge_assignments_url, params: { badge_assignment: { badge_id: @badge_assignment.badge_id, person_id: @badge_assignment.person_id } }
    end

    assert_redirected_to badge_assignment_url(BadgeAssignment.last)
  end

  test "should show badge_assignment" do
    get badge_assignment_url(@badge_assignment)
    assert_response :success
  end

  test "should get edit" do
    get edit_badge_assignment_url(@badge_assignment)
    assert_response :success
  end

  test "should update badge_assignment" do
    patch badge_assignment_url(@badge_assignment), params: { badge_assignment: { badge_id: @badge_assignment.badge_id, person_id: @badge_assignment.person_id } }
    assert_redirected_to badge_assignment_url(@badge_assignment)
  end

  test "should destroy badge_assignment" do
    assert_difference("BadgeAssignment.count", -1) do
      delete badge_assignment_url(@badge_assignment)
    end

    assert_redirected_to badge_assignments_url
  end
end
