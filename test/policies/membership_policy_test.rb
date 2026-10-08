require "test_helper"

class MembershipPolicyTest < ActiveSupport::TestCase
  setup do
    @member = users(:one) # person one, a plain member of team one
    @team = teams(:one)
    @open_team = teams(:two)
    @open_team.update!(join_permission: :has_account)
  end

  def allowed?(user, attrs)
    MembershipPolicy.new(user, Membership.new(attrs)).create?
  end

  def test_create_rejects_a_member_promoting_themselves
    refute allowed?(@member, team: @team, person: people(:one), manager: true)
  end

  def test_create_rejects_a_member_adding_someone_else
    refute allowed?(@member, team: @team, person: people(:two))
  end

  def test_create_allows_joining_an_open_team
    assert allowed?(@member, team: @open_team, person: people(:one))
  end

  def test_create_rejects_joining_an_open_team_as_manager
    refute allowed?(@member, team: @open_team, person: people(:one), manager: true)
  end

  def test_create_rejects_adding_someone_else_to_an_open_team
    refute allowed?(@member, team: @open_team, person: people(:two))
  end

  def test_create_allows_team_managers
    memberships(:one).update!(manager: true)
    assert allowed?(@member, team: @team, person: people(:two), manager: true)
  end

  def test_create_allows_admins
    @member.update!(admin: true)
    assert allowed?(@member, team: @open_team, person: people(:two), manager: true)
  end
end
