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

  test "a non-admin can create a person without a server error" do
    assert_difference -> { Person.count }, 1 do
      post people_path, params: { person: { first_name: "New", last_name: "Scout" } }
    end
    assert_response :redirect
  end

  test "a manager can add a managed member to a team they manage" do
    manager = create_member("mgr@example.com", "Mary", "Leader", manager: true)
    sign_in manager.user
    managed_team = Team.create!(name: "Den A Patrol", team_type: team_types(:one), parent: @team)

    patch person_path(@victim), params: { person: { team_ids: [ @team.id, managed_team.id ] } }

    assert_includes @victim.reload.teams, managed_team
  end

  test "a manager cannot add a managed member to a team they don't manage" do
    manager = create_member("mgr@example.com", "Mary", "Leader", manager: true)
    sign_in manager.user
    locked_team = Team.create!(name: "Admins Only", team_type: team_types(:one))

    patch person_path(@victim), params: { person: { team_ids: [ @team.id, locked_team.id ] } }

    assert_not_includes @victim.reload.teams, locked_team,
      "manager added a member to a team they don't manage"
  end

  test "a manager cannot add themselves to a team they don't manage" do
    manager = create_member("mgr@example.com", "Mary", "Leader", manager: true)
    sign_in manager.user
    locked_team = Team.create!(name: "Admins Only", team_type: team_types(:one))

    patch person_path(manager), params: { person: { team_ids: [ @team.id, locked_team.id ] } }

    assert_not_includes manager.reload.teams, locked_team,
      "manager granted themselves a team they don't manage"
  end

  test "a manager cannot remove a managed member from a team they don't manage" do
    manager = create_member("mgr@example.com", "Mary", "Leader", manager: true)
    sign_in manager.user
    other_team = Team.create!(name: "Den B", team_type: team_types(:one))
    Membership.create!(person: @victim, team: other_team)

    patch person_path(@victim), params: { person: { team_ids: [ @team.id ] } }

    assert_includes @victim.reload.teams, other_team,
      "manager removed a member from a team they don't manage"
  end

  test "a manager cannot re-link a managed member's user account" do
    manager = create_member("mgr@example.com", "Mary", "Leader", manager: true)
    sign_in manager.user
    original_user = @victim.user

    patch person_path(@victim), params: { person: { user_id: manager.user.id } }

    assert_equal original_user, @victim.reload.user,
      "manager re-linked a member's user account"
  end

  private

  def create_member(email, first, last, manager:)
    user = User.create!(email: email, password: "Password1!")
    person = Person.create!(user: user, first_name: first, last_name: last)
    Membership.create!(person: person, team: @team, manager: manager)
    person
  end
end
