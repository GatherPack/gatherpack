require "test_helper"

# Actions that used to load a record through policy_scope (or not at all)
# and then act on it without asking the policy.
class AuthorizationEnforcementTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    host! "localhost"
    @team = Team.create!(name: "Den A", team_type: team_types(:one))
    @member = create_member("member@example.com", manager: false)
    @manager = create_member("manager@example.com", manager: true)
  end

  test "a member can't delete their team" do
    sign_in @member.user

    assert_no_difference -> { Team.count } do
      delete team_path(@team)
    end
  end

  test "a manager can still delete their team" do
    sign_in @manager.user

    assert_difference -> { Team.count }, -1 do
      delete team_path(@team)
    end
  end

  test "a member can't see a team's pending applications" do
    sign_in @member.user

    get applications_team_path(@team)

    assert_redirected_to root_path
  end

  test "a member can't edit or delete their team's announcement" do
    announcement = Announcement.create!(title: "Campout", content: "Bring a tent", team: @team, start_time: 1.day.ago, end_time: 1.day.from_now)
    sign_in @member.user

    patch announcement_path(announcement), params: { announcement: { title: "Hacked" } }
    assert_equal "Campout", announcement.reload.title

    assert_no_difference -> { Announcement.count } do
      delete announcement_path(announcement)
    end
  end

  test "a manager can still edit their team's announcement" do
    announcement = Announcement.create!(title: "Campout", content: "Bring a tent", team: @team, start_time: 1.day.ago, end_time: 1.day.from_now)
    sign_in @manager.user

    patch announcement_path(announcement), params: { announcement: { title: "Campout (updated)" } }

    assert_equal "Campout (updated)", announcement.reload.title
  end

  test "a member can't change or delete their own token" do
    token = Token.create!(value: "1234", tokenable: @member)
    sign_in @member.user

    patch token_path(token), params: { token: { value: "9999" } }
    assert_equal "1234", token.reload.value

    assert_no_difference -> { Token.count } do
      delete token_path(token)
    end
  end

  test "a member can't change or delete someone else's checkin" do
    event = Event.create!(name: "Workday", event_type: event_types(:one), team: @team, start_time: 1.day.from_now, end_time: 2.days.from_now)
    checkin = Checkin.create!(event: event, person: @manager, notes: "Arrived early")
    sign_in @member.user

    patch event_checkin_path(event, checkin), params: { checkin: { notes: "Hacked" } }
    assert_equal "Arrived early", checkin.reload.notes

    assert_no_difference -> { Checkin.count } do
      delete event_checkin_path(event, checkin)
    end
  end

  test "a member can't change or delete a badge type" do
    badge_type = BadgeType.create!(name: "Safety")
    sign_in @member.user

    patch badge_type_path(badge_type), params: { badge_type: { name: "Hacked" } }
    assert_equal "Safety", badge_type.reload.name

    assert_no_difference -> { BadgeType.count } do
      delete badge_type_path(badge_type)
    end
  end

  test "a member can't delete a ledger ownership" do
    ledger = Ledger.create!(name: "Den A Fund", team: @team)
    ownership = LedgerOwnership.create!(ledger: ledger, owner: @manager)
    sign_in @member.user

    assert_no_difference -> { LedgerOwnership.count } do
      delete ledger_ownership_path(ledger, ownership)
    end
  end

  test "only admins can change the time clock's max hours" do
    sign_in @manager.user

    patch update_max_hours_time_clock_punches_path, params: { max_hours: 99 }

    assert_redirected_to root_path
  end

  test "an impersonating admin can always stop impersonating" do
    admin = User.create!(email: "admin@example.com", password: "Password1!", admin: true)
    Person.create!(user: admin, first_name: "Ada", last_name: "Admin")
    sign_in admin
    post impersonate_person_path(@member)

    post stop_impersonating_people_path

    assert_nil session[:impersonated_user_id]
  end

  private

  def create_member(email, manager:)
    user = User.create!(email: email, password: "Password1!")
    person = Person.create!(user: user, first_name: email.split("@").first.capitalize, last_name: "Test")
    Membership.create!(person: person, team: @team, manager: manager)
    person
  end
end
