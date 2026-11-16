require "test_helper"

class StudentPiiTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    host! "localhost"
    @admin = User.create!(email: "admin@example.com", password: "Password1!",
      admin: true)
    Person.create!(user: @admin, first_name: "Ada", last_name: "Admin")

    @student_user = User.create!(email: "kid@example.com", password: "Password1!")
    @student = Person.create!(user: @student_user, first_name: "Sam", last_name: "Student",
      address: "123 Main St", birthday: Date.new(2012, 3, 15))
  end

  # --- Model-level scrubbing ------------------------------------------------

  test "marking a person as student wipes address and birth year" do
    @student.update!(student: true)

    assert_nil @student.address
    assert_equal Person::STUDENT_BIRTHDAY_YEAR, @student.birthday.year
    assert_equal 3, @student.birthday.month
    assert_equal 15, @student.birthday.day
  end

  test "a student cannot reintroduce address or birth year on any save" do
    @student.update!(student: true)

    @student.update!(address: "456 Side St", birthday: Date.new(2012, 7, 4))

    assert_nil @student.address
    assert_equal Person::STUDENT_BIRTHDAY_YEAR, @student.birthday.year
    assert_equal 7, @student.birthday.month
  end

  test "feb 29 birthdays survive the year sentinel" do
    @student.update!(student: true, birthday: Date.new(2012, 2, 29))

    assert_equal 2, @student.birthday.month
    assert_equal 29, @student.birthday.day
  end

  # --- Authorization --------------------------------------------------------

  test "an admin can mark a profile as student via the form" do
    sign_in @admin

    patch person_path(@student), params: { person: { student: true } }

    assert @student.reload.student?
    assert_nil @student.address
  end

  test "a non-admin cannot set the student flag on their own profile" do
    sign_in @student_user

    patch person_path(@student), params: { person: { student: true, first_name: "Sam" } }

    assert_not @student.reload.student?
  end

  test "a student editing their own profile cannot store an address" do
    @student.update!(student: true)
    sign_in @student_user

    patch person_path(@student), params: { person: { address: "789 Sneaky Ln" } }

    assert_nil @student.reload.address
  end
end
