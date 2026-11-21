require "test_helper"

class PersonDisplayNameTest < ActiveSupport::TestCase
  test "display name is filled from first and last names" do
    person = Person.create!(first_name: "Nancy", last_name: "Davolio")

    assert_equal "Nancy Davolio", person.display_name
  end

  test "display name is filled from a first name alone" do
    person = Person.create!(first_name: "Nancy")

    assert_equal "Nancy", person.display_name
    assert_equal "Nancy", person.identifier_name
  end

  test "display name is filled from a last name alone" do
    person = Person.create!(last_name: "Davolio")

    assert_equal "Davolio", person.display_name
  end

  test "a display name that was given is kept" do
    person = Person.create!(first_name: "Nancy", last_name: "Davolio", display_name: "Nan")

    assert_equal "Nan", person.display_name
  end

  test "identifier name falls back to the names, then the id" do
    person = Person.create!(first_name: "Nancy")
    person.update_column(:display_name, nil)

    assert_equal "Nancy", person.reload.identifier_name

    person.update_columns(first_name: nil)
    assert_equal person.id, person.reload.identifier_name
  end
end
