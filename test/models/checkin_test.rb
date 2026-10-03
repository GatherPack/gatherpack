require "test_helper"

class CheckinTest < ActiveSupport::TestCase
  test "the database rejects a second checkin for the same person and event" do
    event = events(:one)
    person = Person.create!(first_name: "Ann", last_name: "Test")
    Checkin.create!(event: event, person: person)

    assert_raises(ActiveRecord::RecordNotUnique) do
      Checkin.new(event: event, person: person).save!(validate: false)
    end
  end
end
