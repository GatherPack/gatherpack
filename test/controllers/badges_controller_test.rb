require "test_helper"

class BadgesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    host! "localhost"
    @team = Team.create!(name: "Den A", team_type: team_types(:one))
    @badge_type = BadgeType.create!(name: "Rank")
    @badge = Badge.create!(name: "Tenderfoot", short: "TF", color: "#00ff00",
      description: "First rank", badge_type: @badge_type, team: @team,
      permission: :added_by_manager)

    @manager = create_member("mandy@example.com", "Mandy", "Manager", manager: true)
    @member = create_member("mel@example.com", "Mel", "Member")
  end

  # --- Duplication ---------------------------------------------------------

  test "a manager gets a new-badge form prefilled from the source badge" do
    sign_in @manager.user

    get duplicate_badge_path(@badge)

    assert_response :success
    assert_select "input[name='badge[name]'][value=?]", @badge.name
    assert_select "input[name='badge[short]'][value=?]", @badge.short
  end

  test "duplicating does not create a badge until the form is submitted" do
    sign_in @manager.user

    assert_no_difference -> { Badge.count } do
      get duplicate_badge_path(@badge)
    end
  end

  test "a non-manager cannot open the duplicate form" do
    sign_in @member.user

    get duplicate_badge_path(@badge)

    assert_response :redirect
  end

  private

  def create_member(email, first, last, manager: false)
    user = User.create!(email: email, password: "Password1!")
    person = Person.create!(user: user, first_name: first, last_name: last)
    Membership.create!(person: person, team: @team, manager: manager)
    person
  end
end
