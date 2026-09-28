require "test_helper"

# Companion to people_authorization_test.rb. Covers the other endpoints that
# performed a state change or exposed data with no `authorize` call. Each test
# signs in as an ordinary, non-manager member and asserts the SECURE outcome:
# the action is refused and nothing changes. Expected to FAIL before the
# corresponding controller/policy fix and PASS after it.
class AuthorizationGapsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    host! "localhost"
    @team = Team.create!(name: "Den A", team_type: team_types(:one))

    @attacker = create_member("joe@example.com", "Joe", "Student")
    @victim   = create_member("sally@example.com", "Sally", "Student")

    @event_type = EventType.create!(name: "Campout")
    @event = Event.create!(name: "Fall Campout", start_time: 1.day.from_now,
      event_type: @event_type, team: @team)

    sign_in @attacker.user
  end

  # --- Events -------------------------------------------------------------

  test "a non-manager cannot edit an event" do
    patch event_path(@event), params: { event: { name: "Hacked" } }
    assert_not_equal "Hacked", @event.reload.name
  end

  test "a non-manager cannot delete an event" do
    assert_no_difference -> { Event.count } do
      delete event_path(@event)
    end
  end

  # --- Check-in field responses ------------------------------------------

  test "a non-manager cannot overwrite another member's check-in response" do
    field = CheckinField.create!(event_type: @event_type, name: "Tent")
    checkin = Checkin.create!(person: @victim, event: @event)
    response = CheckinFieldResponse.create!(checkin: checkin, checkin_field: field,
      response: "Tent 1")

    patch field_update_event_path(@event),
      params: { field_id: response.id, response: "Tent 99" }, as: :json

    assert_equal "Tent 1", response.reload.response
  end

  # --- Relationships ------------------------------------------------------

  test "a bystander cannot delete a relationship between two other people" do
    other = create_member("pat@example.com", "Pat", "Parent")
    type = RelationshipType.create!(parent_label: "Parent", child_label: "Child")
    rel = Relationship.new(relationship_type: type, parent: other, child: @victim)
    rel.save!(validate: false) # seed the edge directly; creation rules aren't under test here

    assert_no_difference -> { Relationship.count } do
      delete person_relationship_path(@victim, rel)
    end
  end

  private

  def create_member(email, first, last)
    user = User.create!(email: email, password: "Password1!")
    person = Person.create!(user: user, first_name: first, last_name: last)
    Membership.create!(person: person, team: @team, manager: false)
    person
  end
end
