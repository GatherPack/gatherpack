require "test_helper"

class AnnouncementsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    host! "localhost"

    # announcements(:one) belongs to teams(:one), so that's the team the
    # manager below runs.
    @team = teams(:one)
    @other_team = Team.create!(name: "Bravo", team_type: team_types(:one))

    @admin_user = User.create!(email: "admin@example.com", password: "Password1!", admin: true)
    Person.create!(user: @admin_user, first_name: "Ada", last_name: "Admin")

    @manager_user = User.create!(email: "manager@example.com", password: "Password1!")
    @manager = Person.create!(user: @manager_user, first_name: "Mary", last_name: "Manager")
    Membership.create!(person: @manager, team: @team, manager: true)

    @member_user = User.create!(email: "member@example.com", password: "Password1!")
    @member = Person.create!(user: @member_user, first_name: "Jo", last_name: "Member")
    Membership.create!(person: @member, team: @team, manager: false)

    @announcement = announcements(:one)
    @valid_attributes = {
      title: "Campout reminder",
      content: "Pack tonight.",
      start_time: 1.day.from_now,
      end_time: 2.days.from_now
    }
  end

  # --- create -------------------------------------------------------------

  test "a manager can create an announcement for a team they manage" do
    sign_in @manager_user

    assert_difference -> { Announcement.count }, 1 do
      post announcements_path, params: { announcement: @valid_attributes.merge(team_id: @team.id) }
    end
    created = Announcement.find_by!(title: "Campout reminder")

    assert_redirected_to announcement_path(created)
    assert_equal @team, created.team
  end

  test "a manager cannot create an announcement with no team" do
    # A team-less announcement is emailed to every person in the system
    # (AnnouncementNotificationRouter), so it must stay admin-only.
    sign_in @manager_user

    assert_no_difference -> { Announcement.count } do
      post announcements_path, params: { announcement: @valid_attributes.merge(team_id: "") }
    end
    assert_redirected_to root_path
  end

  test "a manager cannot create an announcement for a team they don't manage" do
    sign_in @manager_user

    assert_no_difference -> { Announcement.count } do
      post announcements_path, params: { announcement: @valid_attributes.merge(team_id: @other_team.id) }
    end
    assert_redirected_to root_path
  end

  test "an admin can create an announcement with no team" do
    sign_in @admin_user

    assert_difference -> { Announcement.count }, 1 do
      post announcements_path, params: { announcement: @valid_attributes.merge(team_id: "") }
    end
    assert_nil Announcement.find_by!(title: "Campout reminder").team
  end

  test "a plain member cannot create an announcement" do
    sign_in @member_user

    assert_no_difference -> { Announcement.count } do
      post announcements_path, params: { announcement: @valid_attributes.merge(team_id: @team.id) }
    end
  end

  # --- update -------------------------------------------------------------

  test "a manager cannot strip the team off an announcement they manage" do
    sign_in @manager_user

    patch announcement_path(@announcement), params: { announcement: { team_id: "" } }

    assert_equal @team, @announcement.reload.team,
      "manager detached an announcement from its team, broadcasting it to everyone"
  end

  test "a manager cannot move an announcement to a team they don't manage" do
    sign_in @manager_user

    patch announcement_path(@announcement), params: { announcement: { team_id: @other_team.id } }

    assert_equal @team, @announcement.reload.team,
      "manager moved an announcement into a team they don't manage"
  end

  test "a manager can still edit an announcement for a team they manage" do
    sign_in @manager_user

    patch announcement_path(@announcement), params: { announcement: { title: "Renamed" } }

    assert_equal "Renamed", @announcement.reload.title
  end

  test "a plain member cannot edit an announcement" do
    sign_in @member_user

    patch announcement_path(@announcement), params: { announcement: { title: "Hacked" } }

    assert_not_equal "Hacked", @announcement.reload.title
  end

  test "an admin can detach an announcement from its team" do
    sign_in @admin_user

    patch announcement_path(@announcement), params: { announcement: { team_id: "" } }

    assert_nil @announcement.reload.team
  end
end
