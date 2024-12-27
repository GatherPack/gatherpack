require "test_helper"

class MailboxesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mailbox = mailboxes(:one)
  end

  test "should get index" do
    get mailboxes_url
    assert_response :success
  end

  test "should get new" do
    get new_mailbox_url
    assert_response :success
  end

  test "should create mailbox" do
    assert_difference("Mailbox.count") do
      post mailboxes_url, params: { mailbox: { address: @mailbox.address } }
    end

    assert_redirected_to mailbox_url(Mailbox.last)
  end

  test "should show mailbox" do
    get mailbox_url(@mailbox)
    assert_response :success
  end

  test "should get edit" do
    get edit_mailbox_url(@mailbox)
    assert_response :success
  end

  test "should update mailbox" do
    patch mailbox_url(@mailbox), params: { mailbox: { address: @mailbox.address } }
    assert_redirected_to mailbox_url(@mailbox)
  end

  test "should destroy mailbox" do
    assert_difference("Mailbox.count", -1) do
      delete mailbox_url(@mailbox)
    end

    assert_redirected_to mailboxes_url
  end
end
