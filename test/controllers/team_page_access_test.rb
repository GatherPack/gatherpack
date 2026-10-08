require "test_helper"

class TeamPageAccessTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    host! "localhost"

    @parent = Team.create!(name: "Club", team_type: team_types(:one))
    @child = Team.create!(name: "Students", team_type: team_types(:one), parent: @parent)
    @grandchild = Team.create!(name: "Class of 2030", team_type: team_types(:one), parent: @child)
  end

  test "a manager of a parent team sees the full page of a team below it" do
    manager = create_person("manager@example.com")
    Membership.create!(person: manager, team: @parent, manager: true)
    sign_in manager.user

    [ @child, @grandchild ].each do |team|
      get team_path(team)

      assert_response :success
      assert_select "a[href=?]", team_memberships_path(team)
    end
  end

  test "a direct member sees the full page" do
    member = create_person("member@example.com")
    Membership.create!(person: member, team: @grandchild)
    sign_in member.user

    get team_path(@grandchild)

    assert_response :success
    assert_select "a[href=?]", team_memberships_path(@grandchild)
  end

  private

  def create_person(email)
    user = User.create!(email: email, password: "Password1!")
    Person.create!(user: user, first_name: "Test", last_name: "Person")
  end
end
