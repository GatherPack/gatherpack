require "test_helper"

class PeopleAuthorizationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    # Match the host the app generates URLs for, so legitimate success
    # redirects aren't misread as open redirects by the test harness.
    host! "localhost"

    @team = Team.create!(name: "Den A", team_type: team_types(:one))

    # Two ordinary, non-manager members of the same team.
    @attacker = create_member("joe@example.com", "Joe", "Student", manager: false)
    @victim   = create_member("sally@example.com", "Sally", "Student", manager: false)

    sign_in @attacker.user
  end

  test "a non-manager cannot impersonate another member" do
    post impersonate_person_path(@victim)

    # The session must not have been swapped to the victim's user. Pretender
    # stores the impersonated id under this key; it must stay unset.
    assert_nil session[:impersonated_user_id],
      "non-manager was able to impersonate another member"
  end

  test "a non-manager cannot delete another member" do
    assert_no_difference -> { Person.count } do
      delete person_path(@victim)
    end
    assert Person.exists?(@victim.id), "victim record was deleted"
  end

  test "a non-manager cannot edit another member's profile" do
    patch person_path(@victim), params: { person: { phone_number: "555-9999" } }

    assert_not_equal "555-9999", @victim.reload.phone_number,
      "non-manager was able to edit another member's profile"
  end

  test "a non-manager cannot grant themselves teams via mass assignment" do
    locked_team = Team.create!(name: "Admins Only", team_type: team_types(:one))

    patch person_path(@attacker), params: { person: { team_ids: [ locked_team.id ] } }

    assert_not_includes @attacker.reload.teams, locked_team,
      "non-manager granted themselves a team via mass assignment"
  end

  private

  def create_member(email, first, last, manager:)
    user = User.create!(email: email, password: "Password1!")
    person = Person.create!(user: user, first_name: first, last_name: last)
    Membership.create!(person: person, team: @team, manager: manager)
    person
  end
end
