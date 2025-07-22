require "test_helper"

class CalendarNotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @calendar_note = calendar_notes(:one)
  end

  test "should get index" do
    get calendar_notes_url
    assert_response :success
  end

  test "should get new" do
    get new_calendar_note_url
    assert_response :success
  end

  test "should create calendar_note" do
    assert_difference("CalendarNote.count") do
      post calendar_notes_url, params: { calendar_note: { description: @calendar_note.description, end_time: @calendar_note.end_time, noteable_id: @calendar_note.noteable_id, noteable_type: @calendar_note.noteable_type, start_time: @calendar_note.start_time, title: @calendar_note.title } }
    end

    assert_redirected_to calendar_note_url(CalendarNote.last)
  end

  test "should show calendar_note" do
    get calendar_note_url(@calendar_note)
    assert_response :success
  end

  test "should get edit" do
    get edit_calendar_note_url(@calendar_note)
    assert_response :success
  end

  test "should update calendar_note" do
    patch calendar_note_url(@calendar_note), params: { calendar_note: { description: @calendar_note.description, end_time: @calendar_note.end_time, noteable_id: @calendar_note.noteable_id, noteable_type: @calendar_note.noteable_type, start_time: @calendar_note.start_time, title: @calendar_note.title } }
    assert_redirected_to calendar_note_url(@calendar_note)
  end

  test "should destroy calendar_note" do
    assert_difference("CalendarNote.count", -1) do
      delete calendar_note_url(@calendar_note)
    end

    assert_redirected_to calendar_notes_url
  end
end
