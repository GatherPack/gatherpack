require "test_helper"

class TeamTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @team_type = team_types(:one)
  end

  test "should get index" do
    get team_types_url
    assert_response :success
  end

  test "should get new" do
    get new_team_type_url
    assert_response :success
  end

  test "should create team_type" do
    assert_difference("TeamType.count") do
      post team_types_url, params: { team_type: { icon: @team_type.icon, name: @team_type.name } }
    end

    assert_redirected_to team_type_url(TeamType.last)
  end

  test "should show team_type" do
    get team_type_url(@team_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_team_type_url(@team_type)
    assert_response :success
  end

  test "should update team_type" do
    patch team_type_url(@team_type), params: { team_type: { icon: @team_type.icon, name: @team_type.name } }
    assert_redirected_to team_type_url(@team_type)
  end

  test "should destroy team_type" do
    assert_difference("TeamType.count", -1) do
      delete team_type_url(@team_type)
    end

    assert_redirected_to team_types_url
  end
end
