require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    host! "localhost"
    @team = Team.create!(name: "Den A", team_type: team_types(:one))
    @event_type = EventType.create!(name: "Campout")
    @event = Event.create!(name: "Fall Campout", location: "Camp Rainey",
      start_time: Time.utc(2026, 11, 4, 20, 30), end_time: Time.utc(2026, 11, 4, 22, 30),
      event_type: @event_type, team: @team)

    @manager = create_member("mandy@example.com", "Mandy", "Manager", manager: true)
    @member = create_member("mel@example.com", "Mel", "Member")
  end

  # --- Duplication ---------------------------------------------------------

  test "a manager can duplicate an event to multiple dates" do
    sign_in @manager.user

    # Duplicate dates and unparseable values are ignored.
    assert_difference -> { Event.count }, 2 do
      post duplicate_event_path(@event),
        params: { dates: [ "2026-11-05", "2026-11-06", "2026-11-05", "bogus" ] }
    end

    copy = Event.where(name: @event.name).where.not(id: @event.id).order(:start_time).first
    assert_equal Time.utc(2026, 11, 5, 20, 30), copy.start_time
    assert_equal Time.utc(2026, 11, 5, 22, 30), copy.end_time
    assert_equal @event.location, copy.location
    assert_equal @event.event_type_id, copy.event_type_id
    assert_equal @event.team_id, copy.team_id
    assert_equal 0, copy.checkins.count
  end

  test "an open-ended event duplicates without an end time" do
    @event.update!(end_time: nil)
    sign_in @manager.user

    assert_difference -> { Event.count }, 1 do
      post duplicate_event_path(@event), params: { dates: [ "2026-11-09" ] }
    end

    copy = Event.where(name: @event.name).where.not(id: @event.id).first
    assert_equal Time.utc(2026, 11, 9, 20, 30), copy.start_time
    assert_nil copy.end_time
  end

  test "duplicating with no valid dates creates nothing" do
    sign_in @manager.user

    assert_no_difference -> { Event.count } do
      post duplicate_event_path(@event), params: { dates: [ "not-a-date" ] }
    end

    assert_redirected_to duplicate_event_path(@event)
  end

  test "a non-manager cannot duplicate an event" do
    sign_in @member.user

    assert_no_difference -> { Event.count } do
      post duplicate_event_path(@event), params: { dates: [ "2026-11-05" ] }
    end
  end

  private

  def create_member(email, first, last, manager: false)
    user = User.create!(email: email, password: "Password1!")
    person = Person.create!(user: user, first_name: first, last_name: last)
    Membership.create!(person: person, team: @team, manager: manager)
    person
  end
end
