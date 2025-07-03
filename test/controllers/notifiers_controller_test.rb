require "test_helper"

class NotifiersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @notifier = notifiers(:one)
  end

  test "should get index" do
    get notifiers_url
    assert_response :success
  end

  test "should get new" do
    get new_notifier_url
    assert_response :success
  end

  test "should create notifier" do
    assert_difference("Notifier.count") do
      post notifiers_url, params: { notifier: { person_id: @notifier.person_id, schedule: @notifier.schedule, scope: @notifier.scope, target: @notifier.target } }
    end

    assert_redirected_to notifier_url(Notifier.last)
  end

  test "should show notifier" do
    get notifier_url(@notifier)
    assert_response :success
  end

  test "should get edit" do
    get edit_notifier_url(@notifier)
    assert_response :success
  end

  test "should update notifier" do
    patch notifier_url(@notifier), params: { notifier: { person_id: @notifier.person_id, schedule: @notifier.schedule, scope: @notifier.scope, target: @notifier.target } }
    assert_redirected_to notifier_url(@notifier)
  end

  test "should destroy notifier" do
    assert_difference("Notifier.count", -1) do
      delete notifier_url(@notifier)
    end

    assert_redirected_to notifiers_url
  end
end
