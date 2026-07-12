require "test_helper"

class Api::V1::UserInfoControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "oauth-test@example.com", password: "Password1!")
    @app = Doorkeeper::Application.create!(
      name: "Test App",
      redirect_uri: "https://example.com/callback",
      scopes: "user_read"
    )
    @token = Doorkeeper::AccessToken.create!(
      resource_owner_id: @user.id,
      application_id: @app.id,
      scopes: "user_read user_email user_name",
      expires_in: 2.hours
    )
    @token_minimal = Doorkeeper::AccessToken.create!(
      resource_owner_id: @user.id,
      application_id: @app.id,
      scopes: "user_read",
      expires_in: 2.hours
    )
  end

  test "should return OIDC payload with valid token" do
    get api_v1_userinfo_url, headers: { Authorization: "Bearer #{@token.plaintext_token}" }
    assert_response :success

    json = response.parsed_body
    assert_equal @user.neat_id, json["sub"]
  end

  test "should include email when token has user_email scope" do
    get api_v1_userinfo_url, headers: { Authorization: "Bearer #{@token.plaintext_token}" }
    assert_response :success

    json = response.parsed_body
    assert_equal @user.email, json["email"]
    assert_equal true, json["email_verified"]
  end

  test "should not include email when token lacks user_email scope" do
    get api_v1_userinfo_url, headers: { Authorization: "Bearer #{@token_minimal.plaintext_token}" }
    assert_response :success

    json = response.parsed_body
    assert_nil json["email"]
  end

  test "should include name claims when token has user_name scope" do
    get api_v1_userinfo_url, headers: { Authorization: "Bearer #{@token.plaintext_token}" }
    assert_response :success

    json = response.parsed_body
    if @user.person
      assert_equal @user.person.display_name, json["name"]
      assert_equal @user.person.display_name, json["preferred_username"]
      assert json["profile"].present?
    end
  end

  test "should return 401 without token" do
    get api_v1_userinfo_url
    assert_response :unauthorized
  end

  test "should return 401 with expired token" do
    expired = Doorkeeper::AccessToken.create!(
      resource_owner_id: @user.id,
      application_id: @app.id,
      scopes: "user_read",
      expires_in: 0,
      created_at: 3.hours.ago
    )
    get api_v1_userinfo_url, headers: { Authorization: "Bearer #{expired.plaintext_token}" }
    assert_response :unauthorized
  end
end
