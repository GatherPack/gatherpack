require "test_helper"

class MailboxMessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mailbox_message = mailbox_messages(:one)
  end

  test "should get index" do
    get mailbox_messages_url
    assert_response :success
  end

  test "should get new" do
    get new_mailbox_message_url
    assert_response :success
  end

  test "should create mailbox_message" do
    assert_difference("MailboxMessage.count") do
      post mailbox_messages_url, params: { mailbox_message: { body_raw: @mailbox_message.body_raw, from: @mailbox_message.from, mailbox_id: @mailbox_message.mailbox_id, subject: @mailbox_message.subject } }
    end

    assert_redirected_to mailbox_message_url(MailboxMessage.last)
  end

  test "should show mailbox_message" do
    get mailbox_message_url(@mailbox_message)
    assert_response :success
  end

  test "should get edit" do
    get edit_mailbox_message_url(@mailbox_message)
    assert_response :success
  end

  test "should update mailbox_message" do
    patch mailbox_message_url(@mailbox_message), params: { mailbox_message: { body_raw: @mailbox_message.body_raw, from: @mailbox_message.from, mailbox_id: @mailbox_message.mailbox_id, subject: @mailbox_message.subject } }
    assert_redirected_to mailbox_message_url(@mailbox_message)
  end

  test "should destroy mailbox_message" do
    assert_difference("MailboxMessage.count", -1) do
      delete mailbox_message_url(@mailbox_message)
    end

    assert_redirected_to mailbox_messages_url
  end
end
