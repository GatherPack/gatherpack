require "test_helper"

class OauthApplicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @oauth_application = oauth_applications(:one)
  end

  test "should get index" do
    get oauth_applications_url
    assert_response :success
  end

  test "should get new" do
    get new_oauth_application_url
    assert_response :success
  end

  test "should create oauth_application" do
    assert_difference("OauthApplication.count") do
      post oauth_applications_url, params: { oauth_application: { confidential: @oauth_application.confidential, name: @oauth_application.name, redirect_uri: @oauth_application.redirect_uri, scopes: @oauth_application.scopes } }
    end

    assert_redirected_to oauth_application_url(OauthApplication.last)
  end

  test "should show oauth_application" do
    get oauth_application_url(@oauth_application)
    assert_response :success
  end

  test "should get edit" do
    get edit_oauth_application_url(@oauth_application)
    assert_response :success
  end

  test "should update oauth_application" do
    patch oauth_application_url(@oauth_application), params: { oauth_application: { confidential: @oauth_application.confidential, name: @oauth_application.name, redirect_uri: @oauth_application.redirect_uri, scopes: @oauth_application.scopes } }
    assert_redirected_to oauth_application_url(@oauth_application)
  end

  test "should destroy oauth_application" do
    assert_difference("OauthApplication.count", -1) do
      delete oauth_application_url(@oauth_application)
    end

    assert_redirected_to oauth_applications_url
  end
end
