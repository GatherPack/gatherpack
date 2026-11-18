require "test_helper"

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    host! "localhost"
    @team = Team.create!(name: "Den A", team_type: team_types(:one))
  end

  # Regression: policy(Question).create? receives the class on the index page,
  # and the policy dereferenced record.team_id — a 500 for every non-admin.
  test "a non-admin member can render the questions index" do
    member = create_member("mel@example.com", "Mel", "Member")
    sign_in member.user

    get questions_path

    assert_response :success
    assert_match(/New Question/, response.body)
  end

  test "a person with no teams renders the index without the new button" do
    user = User.create!(email: "solo@example.com", password: "Password1!")
    Person.create!(user: user, first_name: "Sol", last_name: "Solo")
    sign_in user

    get questions_path

    assert_response :success
    assert_no_match(/New Question/, response.body)
  end

  private

  def create_member(email, first, last, manager: false)
    user = User.create!(email: email, password: "Password1!")
    person = Person.create!(user: user, first_name: first, last_name: last)
    Membership.create!(person: person, team: @team, manager: manager)
    person
  end
end
