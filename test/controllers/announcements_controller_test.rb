require "test_helper"

class AnnouncementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @announcement = announcements(:one)
  end

  test "should get index" do
    get announcements_url
    assert_response :success
  end

  test "should get new" do
    get new_announcement_url
    assert_response :success
  end

  test "should create announcement" do
    assert_difference("Announcement.count") do
      post announcements_url, params: { announcement: { content: @announcement.content, end_time: @announcement.end_time, start_time: @announcement.start_time, team_id: @announcement.team_id, title: @announcement.title } }
    end

    assert_redirected_to announcement_url(announcement.last)
  end

  test "should show announcement" do
    get announcement_url(@announcement)
    assert_response :success
  end

  test "should get edit" do
    get edit_announcement_url(@announcement)
    assert_response :success
  end

  test "should update announcement" do
    patch announcement_url(@announcement), params: { announcement: { content: @announcement.content, end_time: @announcement.end_time, start_time: @announcement.start_time, team_id: @announcement.team_id, title: @announcement.title } }
    assert_redirected_to announcement_url(@announcement)
  end

  test "should destroy announcement" do
    assert_difference("Announcement.count", -1) do
      delete announcement_url(@announcement)
    end

    assert_redirected_to announcements_url
  end
end
