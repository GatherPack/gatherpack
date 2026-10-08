require "test_helper"

class UserSearchTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    host! "localhost"
    @admin = User.create!(email: "admin@example.com", password: "Password1!", admin: true)
    Person.create!(user: @admin, first_name: "Ada", last_name: "Admin")
    sign_in @admin
  end

  test "user search results show the person's name" do
    get combo_search_path(q: "Ada", scope: "users", format: :turbo_stream)

    assert_response :success
    assert_includes response.body, %(data-filterable-as="Ada Admin")
  end

  test "a user without a person shows their email" do
    User.create!(email: "no-person@example.com", password: "Password1!")

    get combo_search_path(q: "no-person", scope: "users", format: :turbo_stream)

    assert_includes response.body, %(data-filterable-as="no-person@example.com")
  end
end
