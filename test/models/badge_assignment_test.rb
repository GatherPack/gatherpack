require "test_helper"

class BadgeAssignmentTest < ActiveSupport::TestCase
  setup do
    @badge = Badge.create!(name: "First Aid", short: "FA", color: "#336699", badge_type: badge_types(:one))
    @person = Person.create!(first_name: "Ann", last_name: "Test")
    BadgeAssignment.create!(badge: @badge, person: @person)
  end

  test "a person can only hold a badge once" do
    duplicate = BadgeAssignment.new(badge: @badge, person: @person)

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:person], "already has this badge"
  end

  test "the database rejects a duplicate that skips validation" do
    assert_raises(ActiveRecord::RecordNotUnique) do
      BadgeAssignment.new(badge: @badge, person: @person).save!(validate: false)
    end
  end
end
