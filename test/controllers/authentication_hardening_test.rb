require "test_helper"

class AuthenticationHardeningTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    host! "localhost"
  end

  # --- Confirmable ---------------------------------------------------------

  test "an unconfirmed local user cannot sign in" do
    User.create!(email: "new@example.com", password: "Password1!")

    post user_session_path, params: { user: { email: "new@example.com", password: "Password1!" } }

    assert_redirected_to new_user_session_path
    assert_match(/confirm/i, flash[:alert])
  end

  test "a confirmed user can sign in" do
    user = User.new(email: "ok@example.com", password: "Password1!")
    user.skip_confirmation!
    user.save!

    post user_session_path, params: { user: { email: "ok@example.com", password: "Password1!" } }

    assert_redirected_to root_path
  end

  test "oauth signups are created confirmed" do
    info = Struct.new(:email, :first_name, :last_name).new("oauth@example.com", "Oscar", "Auth")
    provider_data = Struct.new(:provider, :uid, :info).new("google_oauth2", "12345", info)

    user = User.create_from_provider_data(provider_data)

    assert user.persisted?
    assert user.confirmed?
  end

  test "admin-created users via person form are confirmed and can sign in" do
    admin = User.new(email: "admin@example.com", password: "Password1!")
    admin.skip_confirmation!
    admin.save!
    Person.create!(user: admin, first_name: "Ada", last_name: "Admin")
    admin.update!(admin: true)
    sign_in admin

    post people_path, params: { person: { first_name: "Nia", last_name: "New", email: "nia@example.com" } }

    created = User.find_by(email: "nia@example.com")
    assert created.present?
    assert created.confirmed?
  end
end
