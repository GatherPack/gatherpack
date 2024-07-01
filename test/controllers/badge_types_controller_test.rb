require "test_helper"

class BadgeTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @badge_type = badge_types(:one)
  end

  test "should get index" do
    get badge_types_url
    assert_response :success
  end

  test "should get new" do
    get new_badge_type_url
    assert_response :success
  end

  test "should create badge_type" do
    assert_difference("BadgeType.count") do
      post badge_types_url, params: { badge_type: { name: @badge_type.name } }
    end

    assert_redirected_to badge_type_url(BadgeType.last)
  end

  test "should show badge_type" do
    get badge_type_url(@badge_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_badge_type_url(@badge_type)
    assert_response :success
  end

  test "should update badge_type" do
    patch badge_type_url(@badge_type), params: { badge_type: { name: @badge_type.name } }
    assert_redirected_to badge_type_url(@badge_type)
  end

  test "should destroy badge_type" do
    assert_difference("BadgeType.count", -1) do
      delete badge_type_url(@badge_type)
    end

    assert_redirected_to badge_types_url
  end
end
