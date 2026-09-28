require "test_helper"

class MembershipsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    host! "localhost"
    @team = teams(:one)
    @member = people(:one)
    @candidate = Person.create!(first_name: "Carol", last_name: "Carter", display_name: "Carol Carter")

    @user = users(:one)
    @user.update!(admin: true)
    sign_in @user
  end

  test "membership type filters" do
    child = Team.create!(name: "Child Crew", team_type: team_types(:one), parent: @team)
    Membership.create!(person: @candidate, team: child)
    Membership.create!(person: @member, team: child)
    parent = Team.create!(name: "Parent Org", team_type: team_types(:one))
    @team.update!(parent: parent)
    boss = Person.create!(first_name: "Pat", last_name: "Parent", display_name: "Pat Parent")
    Membership.create!(person: boss, team: parent, manager: true)
    in_grid = ->(person) { "##{ActionView::RecordIdentifier.dom_id(person)}" }

    get team_memberships_path(@team, member_type: "parent_manager")
    assert_select in_grid.(boss)
    assert_select in_grid.(@candidate), count: 0

    # @member is on both this team and the child team, so only @candidate counts.
    get team_memberships_path(@team, member_type: "child_member")
    assert_select in_grid.(@candidate)
    assert_select in_grid.(@member), count: 0
  end
end
