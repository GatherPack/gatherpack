require "test_helper"

class MembershipTest < ActiveSupport::TestCase
  setup do
    @team = Team.create!(name: "Den A", team_type: team_types(:one))
    @person = Person.create!(first_name: "Ann", last_name: "Test")
    Membership.create!(team: @team, person: @person)
  end

  test "a person can only belong to a team once" do
    duplicate = Membership.new(team: @team, person: @person, manager: true)

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:person], "is already a member of this team"
  end

  test "the database rejects a duplicate that skips validation" do
    assert_raises(ActiveRecord::RecordNotUnique) do
      Membership.new(team: @team, person: @person).save!(validate: false)
    end
  end

  test "the same person can belong to another team" do
    other = Team.create!(name: "Den B", team_type: team_types(:one))

    assert Membership.new(team: other, person: @person).valid?
  end
end
