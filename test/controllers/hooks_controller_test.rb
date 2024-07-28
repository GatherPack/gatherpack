require "test_helper"

class HooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hook = hooks(:one)
  end

  test "should get index" do
    get hooks_url
    assert_response :success
  end

  test "should get new" do
    get new_hook_url
    assert_response :success
  end

  test "should create hook" do
    assert_difference("Hook.count") do
      post hooks_url, params: { hook: { code: @hook.code, event: @hook.event, name: @hook.name } }
    end

    assert_redirected_to hook_url(Hook.last)
  end

  test "should show hook" do
    get hook_url(@hook)
    assert_response :success
  end

  test "should get edit" do
    get edit_hook_url(@hook)
    assert_response :success
  end

  test "should update hook" do
    patch hook_url(@hook), params: { hook: { code: @hook.code, event: @hook.event, name: @hook.name } }
    assert_redirected_to hook_url(@hook)
  end

  test "should destroy hook" do
    assert_difference("Hook.count", -1) do
      delete hook_url(@hook)
    end

    assert_redirected_to hooks_url
  end
end
