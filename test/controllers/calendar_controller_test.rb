require "test_helper"

class CalendarControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    host! "localhost"
    @den_a = Team.create!(name: "Den A", team_type: team_types(:one))
    @den_b = Team.create!(name: "Den B", team_type: team_types(:one))
    @ann = create_member("ann@example.com", "Ann", @den_a, birthday: Date.new(2015, 6, 15))
    @bea = create_member("bea@example.com", "Bea", @den_b, birthday: Date.new(2014, 6, 16))
    admin = User.create!(email: "admin@example.com", password: "Password1!", admin: true)
    Person.create!(user: admin, first_name: "Ada", last_name: "Admin")
    sign_in admin
  end

  test "birthdays can be filtered by team" do
    get "/calendar/calendar.json", params: birthday_params(team_id_eq: @den_a.id)

    assert_response :success
    titles = response.parsed_body.map { |entry| entry["title"] }
    assert_includes titles, "Ann Test's Birthday"
    assert_not_includes titles, "Bea Test's Birthday"
  end

  test "birthdays for one person within a team" do
    get "/calendar/calendar.json", params: birthday_params(team_id_eq: @den_a.id).merge(person_id: @ann.id)

    assert_response :success
    assert_equal [ "Ann Test's Birthday" ], response.parsed_body.map { |entry| entry["title"] }
  end

  private

  def birthday_params(**query)
    { birthdays: "1", start_time: "2026-01-01", end_time: "2026-12-31", q: { name_i_cont: "" }.merge(query) }
  end

  def create_member(email, first, team, **attributes)
    user = User.create!(email: email, password: "Password1!")
    person = Person.create!(user: user, first_name: first, last_name: "Test", **attributes)
    Membership.create!(person: person, team: team)
    person
  end
end
