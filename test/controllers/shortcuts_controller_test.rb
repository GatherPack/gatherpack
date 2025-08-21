require "test_helper"

class ShortcutsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shortcut = shortcuts(:one)
  end

  test "should get index" do
    get shortcuts_url
    assert_response :success
  end

  test "should get new" do
    get new_shortcut_url
    assert_response :success
  end

  test "should create shortcut" do
    assert_difference("Shortcut.count") do
      post shortcuts_url, params: { shortcut: { color: @shortcut.color, icon: @shortcut.icon, name: @shortcut.name, target: @shortcut.target, team_id: @shortcut.team_id } }
    end

    assert_redirected_to shortcut_url(Shortcut.last)
  end

  test "should show shortcut" do
    get shortcut_url(@shortcut)
    assert_response :success
  end

  test "should get edit" do
    get edit_shortcut_url(@shortcut)
    assert_response :success
  end

  test "should update shortcut" do
    patch shortcut_url(@shortcut), params: { shortcut: { color: @shortcut.color, icon: @shortcut.icon, name: @shortcut.name, target: @shortcut.target, team_id: @shortcut.team_id } }
    assert_redirected_to shortcut_url(@shortcut)
  end

  test "should destroy shortcut" do
    assert_difference("Shortcut.count", -1) do
      delete shortcut_url(@shortcut)
    end

    assert_redirected_to shortcuts_url
  end
end
