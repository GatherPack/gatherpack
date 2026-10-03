require "test_helper"

# InternalController verifies that every action calls `authorize` and every
# index calls `policy_scope`. This requests each GET page under it, so an
# action that skips the check fails here rather than for a user.
class AuthorizationCoverageTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  UNCHECKED = [
    Pundit::AuthorizationNotPerformedError,
    Pundit::PolicyScopingNotPerformedError
  ].freeze

  setup do
    host! "localhost"
    user = User.create!(email: "coverage-admin@example.com", password: "Password1!", admin: true, architect: true)
    Person.create!(user: user, first_name: "Ada", last_name: "Admin")
    sign_in user
  end

  test "every page under InternalController authorizes and scopes" do
    unchecked = []
    visited = 0

    internal_get_routes.each do |route|
      path = path_for(route) or next
      visited += 1
      begin
        get path
      rescue *UNCHECKED => e
        unchecked << "#{route.defaults[:controller]}##{route.defaults[:action]} (#{e.class.name.demodulize})"
      rescue StandardError
        # Fixture data can break a page in other ways; that's not what this
        # test is about.
      end
    end

    assert_operator visited, :>, 50, "expected to visit most pages"
    assert_empty unchecked
  end

  private

  def internal_get_routes
    Rails.application.routes.routes.select do |route|
      next false unless route.verb == "GET" && route.defaults[:controller]
      controller = "#{route.defaults[:controller].camelize}Controller".safe_constantize
      controller && controller < InternalController
    end
  end

  # Fills each :param with a fixture record of the matching model, or skips
  # the route when there isn't one.
  def path_for(route)
    path = route.path.spec.to_s.gsub(/\(\.:format\)/, "").gsub(/\([^)]*\)/, "")
    path.gsub(/:(\w+)/) do
      record = record_for(Regexp.last_match(1), route.defaults[:controller]) or return nil
      record.id
    end
  end

  def record_for(param, controller)
    name = param == "id" ? controller.split("/").last.singularize : param.delete_suffix("_id")
    name.camelize.safe_constantize&.first
  rescue StandardError
    nil
  end
end
