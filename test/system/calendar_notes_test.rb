require "application_system_test_case"

class CalendarNotesTest < ApplicationSystemTestCase
  setup do
    @calendar_note = calendar_notes(:one)
  end

  test "visiting the index" do
    visit calendar_notes_url
    assert_selector "h1", text: "Calendar notes"
  end

  test "should create calendar note" do
    visit calendar_notes_url
    click_on "New calendar note"

    fill_in "Description", with: @calendar_note.description
    fill_in "End time", with: @calendar_note.end_time
    fill_in "Noteable", with: @calendar_note.noteable_id
    fill_in "Noteable type", with: @calendar_note.noteable_type
    fill_in "Start time", with: @calendar_note.start_time
    fill_in "Title", with: @calendar_note.title
    click_on "Create Calendar note"

    assert_text "Calendar note was successfully created"
    click_on "Back"
  end

  test "should update Calendar note" do
    visit calendar_note_url(@calendar_note)
    click_on "Edit this calendar note", match: :first

    fill_in "Description", with: @calendar_note.description
    fill_in "End time", with: @calendar_note.end_time
    fill_in "Noteable", with: @calendar_note.noteable_id
    fill_in "Noteable type", with: @calendar_note.noteable_type
    fill_in "Start time", with: @calendar_note.start_time
    fill_in "Title", with: @calendar_note.title
    click_on "Update Calendar note"

    assert_text "Calendar note was successfully updated"
    click_on "Back"
  end

  test "should destroy Calendar note" do
    visit calendar_note_url(@calendar_note)
    click_on "Destroy this calendar note", match: :first

    assert_text "Calendar note was successfully destroyed"
  end
end
