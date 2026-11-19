require "test_helper"

class BadgeAssignmentsBulkTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    host! "localhost"
    @team = Team.create!(name: "Den A", team_type: team_types(:one))
    @badge_type = BadgeType.create!(name: "Rank")
    @badge = Badge.create!(name: "Tenderfoot", short: "TF", color: "#00ff00",
      badge_type: @badge_type, team: @team, permission: :added_by_manager)

    @manager = create_member("mandy@example.com", "Mandy", "Manager", manager: true)
    @member = create_member("mel@example.com", "Mel", "Member")
    @outsider_user = User.create!(email: "out@example.com", password: "Password1!")
    @outsider = Person.create!(user: @outsider_user, first_name: "Olly", last_name: "Out")
  end

  # --- Bulk page -------------------------------------------------------------

  test "a manager sees the bulk assign page with current assignments checked" do
    @badge.badge_assignments.create!(person: @member)
    sign_in @manager.user

    get bulk_badge_badge_assignments_path(@badge)

    assert_response :success
    assert_select "input[data-person-id='#{@member.id}'][checked]"
    assert_select "input[data-person-id='#{@manager.id}']:not([checked])"
  end

  test "a non-manager cannot load the bulk assign page" do
    sign_in @member.user

    get bulk_badge_badge_assignments_path(@badge)

    assert_response :redirect
  end

  # --- Bulk toggles ----------------------------------------------------------

  test "checking a box assigns the badge with the chosen earned date" do
    sign_in @manager.user

    assert_difference -> { BadgeAssignment.count }, 1 do
      patch bulk_badge_badge_assignments_path(@badge),
        params: { person_id: @member.id, assigned: true, earned_on: "2026-11-01" }, as: :json
    end

    assert_response :success
    assignment = @badge.badge_assignments.find_by(person: @member)
    assert_equal Date.new(2026, 11, 1), assignment.earned_at.to_date
  end

  test "unchecking a box removes the assignment" do
    @badge.badge_assignments.create!(person: @member)
    sign_in @manager.user

    assert_difference -> { BadgeAssignment.count }, -1 do
      patch bulk_badge_badge_assignments_path(@badge),
        params: { person_id: @member.id, assigned: false }, as: :json
    end

    assert_response :success
  end

  test "assigning a non-team member fails with validation errors" do
    sign_in @manager.user

    assert_no_difference -> { BadgeAssignment.count } do
      patch bulk_badge_badge_assignments_path(@badge),
        params: { person_id: @outsider.id, assigned: true, earned_on: "2026-11-01" }, as: :json
    end

    assert_response :unprocessable_entity
  end

  test "a non-manager cannot toggle assignments" do
    sign_in @member.user

    assert_no_difference -> { BadgeAssignment.count } do
      patch bulk_badge_badge_assignments_path(@badge),
        params: { person_id: @member.id, assigned: true }, as: :json
    end
  end

  # --- earned_at -------------------------------------------------------------

  test "earned_at defaults to now when not supplied" do
    assignment = @badge.badge_assignments.create!(person: @member)

    assert_in_delta Time.current.to_i, assignment.earned_at.to_i, 5
  end

  private

  def create_member(email, first, last, manager: false)
    user = User.create!(email: email, password: "Password1!")
    person = Person.create!(user: user, first_name: first, last_name: last)
    Membership.create!(person: person, team: @team, manager: manager)
    person
  end
end
