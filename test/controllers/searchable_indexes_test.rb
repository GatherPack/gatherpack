require "test_helper"

# Regression test: Ransack requires ransackable_associations allowlists, and
# every model with has_paper_trail gains a "versions" association that trips
# the check. Each searchable index page must render without raising.
class SearchableIndexesTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    host! "localhost"
    user = User.create!(email: "admin@example.com", password: "Password1!")
    Person.create!(user: user, first_name: "Ada", last_name: "Admin")
    user.update!(admin: true, architect: true)
    sign_in user
  end

  %w[
    /budget_periods
    /budgets
    /checkin_fields
    /event_types
    /gateways
    /hooks
    /ledger_tags
    /mailboxes
    /oauth_applications
    /relationship_types
    /reports
    /shortcuts
    /team_types
    /variables
  ].each do |path|
    test "#{path} index renders its search form" do
      get path
      assert_response :success
    end
  end
end
