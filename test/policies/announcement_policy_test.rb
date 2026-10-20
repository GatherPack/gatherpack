require "test_helper"

class AnnouncementPolicyTest < ActiveSupport::TestCase
  setup do
    # announcements(:one) belongs to teams(:one), so that's the team the
    # manager below runs.
    @team = teams(:one)
    @other_team = Team.create!(name: "Bravo", team_type: team_types(:one))

    @admin_user = User.create!(email: "admin@example.com", password: "Password1!", admin: true)
    @admin = Person.create!(user: @admin_user, first_name: "Ada", last_name: "Admin")

    @manager_user = User.create!(email: "manager@example.com", password: "Password1!")
    @manager = Person.create!(user: @manager_user, first_name: "Mary", last_name: "Manager")
    Membership.create!(person: @manager, team: @team, manager: true)

    @member_user = User.create!(email: "member@example.com", password: "Password1!")
    @member = Person.create!(user: @member_user, first_name: "Jo", last_name: "Member")
    Membership.create!(person: @member, team: @team, manager: false)
  end

  # --- new? ---------------------------------------------------------------

  test "an admin may open the new announcement form" do
    assert AnnouncementPolicy.new(@admin_user, Announcement).new?
  end

  test "a manager may open the new announcement form" do
    assert AnnouncementPolicy.new(@manager_user, Announcement).new?
  end

  test "a plain member may not open the new announcement form" do
    assert_not AnnouncementPolicy.new(@member_user, Announcement).new?
  end

  # --- create? ------------------------------------------------------------

  test "an admin may create an announcement with no team" do
    assert AnnouncementPolicy.new(@admin_user, Announcement.new).create?
  end

  test "a manager may create an announcement for a team they manage" do
    assert AnnouncementPolicy.new(@manager_user, Announcement.new(team: @team)).create?
  end

  test "a manager may not create an announcement with no team" do
    # No team means the notification goes to Person.all, so it's admin-only.
    assert_not AnnouncementPolicy.new(@manager_user, Announcement.new).create?
  end

  test "a manager may not create an announcement for a team they don't manage" do
    assert_not AnnouncementPolicy.new(@manager_user, Announcement.new(team: @other_team)).create?
  end

  test "a plain member may not create an announcement" do
    assert_not AnnouncementPolicy.new(@member_user, Announcement.new(team: @team)).create?
  end

  # --- update? ------------------------------------------------------------

  test "an admin may clear a team's announcement team" do
    announcement = announcements(:one)
    assert AnnouncementPolicy.new(@admin_user, announcement.tap { |a| a.team = nil }).update?
  end

  test "a manager may update an announcement for a team they manage" do
    assert AnnouncementPolicy.new(@manager_user, announcements(:one)).update?
  end

  test "a manager may not move an announcement out to everyone" do
    announcement = announcements(:one)
    assert_not AnnouncementPolicy.new(@manager_user, announcement.tap { |a| a.team = nil }).update?
  end

  test "a manager may not move an announcement to a team they don't manage" do
    announcement = announcements(:one)
    assert_not AnnouncementPolicy.new(@manager_user, announcement.tap { |a| a.team = @other_team }).update?
  end

  test "a plain member may not update an announcement" do
    assert_not AnnouncementPolicy.new(@member_user, announcements(:one)).update?
  end

  # --- scope --------------------------------------------------------------

  test "scope includes team-less announcements for everyone" do
    announcement = Announcement.create!(title: "All hands", content: "Hi",
      start_time: 1.day.from_now, end_time: 2.days.from_now)

    scoped = AnnouncementPolicy::Scope.new(@member_user, Announcement).resolve
    assert_includes scoped, announcement
    assert_includes scoped, announcements(:one)
  end
end
