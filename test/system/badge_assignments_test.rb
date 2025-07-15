require "application_system_test_case"

class BadgeAssignmentsTest < ApplicationSystemTestCase
  setup do
    @badge_assignment = badge_assignments(:one)
  end

  test "visiting the index" do
    visit badge_assignments_url
    assert_selector "h1", text: "Badge assignments"
  end

  test "should create badge assignment" do
    visit badge_assignments_url
    click_on "New badge assignment"

    fill_in "Badge", with: @badge_assignment.badge_id
    fill_in "Person", with: @badge_assignment.person_id
    click_on "Create Badge assignment"

    assert_text "Badge assignment was successfully created"
    click_on "Back"
  end

  test "should update Badge assignment" do
    visit badge_assignment_url(@badge_assignment)
    click_on "Edit this badge assignment", match: :first

    fill_in "Badge", with: @badge_assignment.badge_id
    fill_in "Person", with: @badge_assignment.person_id
    click_on "Update Badge assignment"

    assert_text "Badge assignment was successfully updated"
    click_on "Back"
  end

  test "should destroy Badge assignment" do
    visit badge_assignment_url(@badge_assignment)
    click_on "Destroy this badge assignment", match: :first

    assert_text "Badge assignment was successfully destroyed"
  end
end
