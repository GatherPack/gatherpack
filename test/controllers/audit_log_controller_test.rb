require "test_helper"

class AuditLogControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get audit_log_index_url
    assert_response :success
  end

  test "should get show" do
    get audit_log_show_url
    assert_response :success
  end

  test "should get destory" do
    get audit_log_destory_url
    assert_response :success
  end
end
