require "test_helper"

class TeamsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    host! "localhost"

    @team = Team.create!(name: "Open Den", team_type: team_types(:one), join_permission: "has_account")
    @team.questions.create!(person: people(:one), title: "Who is bringing snacks?", content: "Asking for a friend.")
  end

  test "a non-member sees the public page of a team with questions enabled" do
    assert GatherPack::Features.enabled?(:qa), "this test needs the Q&A feature on (its default)"
    sign_in create_person("visitor@example.com").user

    get team_path(@team)

    assert_response :success
    assert_select "h1", text: /Open Den/
    assert_select "a[href=?]", team_memberships_path(@team), count: 0
  end

  test "a member sees the full page with its recent questions" do
    member = create_person("member@example.com")
    Membership.create!(person: member, team: @team)
    sign_in member.user

    get team_path(@team)

    assert_response :success
    assert_select "a[href=?]", team_memberships_path(@team)
    assert_match "Who is bringing snacks?", response.body
  end

  private

  def create_person(email)
    user = User.create!(email: email, password: "Password1!")
    Person.create!(user: user, first_name: "Test", last_name: "Person")
  end
end
