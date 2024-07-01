require "application_system_test_case"

class AnnouncementsTest < ApplicationSystemTestCase
  setup do
    @announcement = announcements(:one)
  end

  test "visiting the index" do
    visit announcements_url
    assert_selector "h1", text: "announcements"
  end

  test "should create announcement" do
    visit announcements_url
    click_on "New Announcement"

    fill_in "content", with: @announcement.content
    fill_in "End time", with: @announcement.end_time
    fill_in "Start time", with: @announcement.start_time
    fill_in "Team", with: @announcement.team_id
    fill_in "Title", with: @announcement.title
    click_on "Create Announcement"

    assert_text "Announcement was successfully created"
    click_on "Back"
  end

  test "should update announcement" do
    visit announcement_url(@announcement)
    click_on "Edit this announcement", match: :first

    fill_in "content", with: @announcement.content
    fill_in "End time", with: @announcement.end_time.to_s
    fill_in "Start time", with: @announcement.start_time.to_s
    fill_in "Team", with: @announcement.team_id
    fill_in "Title", with: @announcement.title
    click_on "Update Announcement"

    assert_text "Announcement was successfully updated"
    click_on "Back"
  end

  test "should destroy announcement" do
    visit announcement_url(@announcement)
    click_on "Destroy this announcement", match: :first

    assert_text "Announcement was successfully destroyed"
  end
end
