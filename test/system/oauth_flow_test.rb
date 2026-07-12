require "application_system_test_case"

class OauthFlowTest < ApplicationSystemTestCase
  setup do
    @admin = User.create!(email: "admin@example.com", password: "Password1!", admin: true)
    @app = Doorkeeper::Application.create!(
      name: "My Test App",
      redirect_uri: "https://example.com/callback",
      scopes: "user_read user_email"
    )
  end

  test "unauthenticated user is redirected to login when visiting authorization page" do
    visit oauth_authorization_path(
      client_id: @app.uid,
      redirect_uri: @app.redirect_uri,
      response_type: "code",
      scope: "user_read user_email"
    )
    assert_selector "h2", text: "Sign in with Email & Password"
  end

  test "authenticated user sees consent page" do
    visit new_user_session_path
    fill_in "Email", with: @admin.email
    fill_in "Password", with: "Password1!"
    click_button "Sign in"

    visit oauth_authorization_path(
      client_id: @app.uid,
      redirect_uri: @app.redirect_uri,
      response_type: "code",
      scope: "user_read user_email"
    )

    assert_selector "h2", text: /Authorize/
    assert_text @app.name
    assert_button "Authorize"
    assert_button "Deny"
  end
end
