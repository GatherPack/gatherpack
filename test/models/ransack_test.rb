require "test_helper"

class RansackTest < ActiveSupport::TestCase
  setup do
    @person = Person.create!(first_name: "Zebra", last_name: "Xylophone", display_name: "Zebra Xylophone")
    @person2 = Person.create!(first_name: "Alpha", last_name: "Beta", display_name: "Alpha Beta")
    @team = Team.create!(name: "Ransack Test Team", team_type: team_types(:one))
    Membership.create!(person: @person, team: @team)
  end

  test "ransack search with _cont predicate finds matching records" do
    q = Person.ransack(first_name_or_last_name_or_display_name_cont: "Zebra")
    results = q.result(distinct: true)

    assert_includes results, @person
    assert_not_includes results, @person2
  end

  test "ransack search with _cont predicate is case sensitive by default" do
    q = Person.ransack(first_name_or_last_name_or_display_name_cont: "zebra")
    results = q.result(distinct: true)

    # _cont uses LIKE (case-sensitive) - "zebra" won't match "Zebra"
    assert_not_includes results, @person
    assert_not_includes results, @person2
  end

  test "ransack search with _i_cont predicate is case insensitive" do
    q = Person.ransack(first_name_or_last_name_or_display_name_i_cont: "zebra")
    results = q.result(distinct: true)

    assert_includes results, @person
    assert_not_includes results, @person2
  end

  test "ransack search with user association works" do
    user = User.create!(email: "test@example.com", password: "password123")
    person_with_user = Person.create!(first_name: "With", last_name: "User", display_name: "With User", user: user)
    person_without_user = Person.create!(first_name: "Without", last_name: "User", display_name: "Without User")

    q = Person.ransack(user_email_cont: "test")
    results = q.result(distinct: true)

    assert_includes results, person_with_user
    assert_not_includes results, person_without_user
  end

  test "ransack sort links work" do
    # Only test with our created records by filtering
    q = Person.where(id: [@person.id, @person2.id]).ransack({ s: "last_name asc" })
    results = q.result(distinct: true).to_a

    # Alpha Beta should come before Zebra Xylophone alphabetically by last_name
    assert_equal @person2.id, results.first.id
    assert_equal @person.id, results.second.id
  end

  test "ransack search with multiple conditions" do
    q = Person.ransack(first_name_cont: "Zebra", last_name_cont: "Xylophone")
    results = q.result(distinct: true)

    assert_includes results, @person
    assert_not_includes results, @person2
  end

  test "ransack _start predicate works" do
    q = Person.ransack(first_name_start: "Z")
    results = q.result(distinct: true)

    assert_includes results, @person
    assert_not_includes results, @person2
  end

  test "ransack _end predicate works" do
    q = Person.ransack(last_name_end: "phone")
    results = q.result(distinct: true)

    assert_includes results, @person
    assert_not_includes results, @person2
  end

  test "ransack _eq predicate works" do
    q = Person.ransack(display_name_eq: "Zebra Xylophone")
    results = q.result(distinct: true)

    assert_includes results, @person
    assert_not_includes results, @person2
  end

  test "ransack distinct true removes duplicates when joining" do
    # Create a user and associate with person to test distinct through a join
    user = User.create!(email: "duplicate-test@example.com", password: "password123")
    @person.update!(user: user)
    
    # Search through user association - should return person only once despite join
    q = Person.ransack(user_email_cont: "duplicate-test")
    results = q.result(distinct: true)

    assert_equal 1, results.count
    assert_equal @person.id, results.first.id
  end
end