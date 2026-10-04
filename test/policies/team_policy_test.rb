require "test_helper"

class TeamPolicyTest < ActiveSupport::TestCase
  def test_scope
  end

  def test_show
  end

  def test_create
  end

  def test_update
  end

  def test_destroy
  end

  def test_show_full
    parent = Team.create!(name: "Club", team_type: team_types(:one))
    child = Team.create!(name: "Students", team_type: team_types(:one), parent: parent)
    grandchild = Team.create!(name: "Class of 2030", team_type: team_types(:one), parent: child)

    parent_manager = create_person("parent-manager@example.com")
    Membership.create!(person: parent_manager, team: parent, manager: true)
    member = create_person("member@example.com")
    Membership.create!(person: member, team: grandchild)
    parent_member = create_person("parent-member@example.com")
    Membership.create!(person: parent_member, team: parent)
    outsider = create_person("outsider@example.com")

    assert TeamPolicy.new(parent_manager.user, child).show_full?
    assert TeamPolicy.new(parent_manager.user, grandchild).show_full?
    assert TeamPolicy.new(member.user, grandchild).show_full?
    assert_not TeamPolicy.new(parent_member.user, child).show_full?
    assert_not TeamPolicy.new(outsider.user, child).show_full?
  end

  private

  def create_person(email)
    user = User.create!(email: email, password: "Password1!")
    Person.create!(user: user, first_name: "Test", last_name: "Person")
  end
end
