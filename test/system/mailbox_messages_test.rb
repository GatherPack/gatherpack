require "application_system_test_case"

class MailboxMessagesTest < ApplicationSystemTestCase
  setup do
    @mailbox_message = mailbox_messages(:one)
  end

  test "visiting the index" do
    visit mailbox_messages_url
    assert_selector "h1", text: "Mailbox messages"
  end

  test "should create mailbox message" do
    visit mailbox_messages_url
    click_on "New mailbox message"

    fill_in "Body raw", with: @mailbox_message.body_raw
    fill_in "From", with: @mailbox_message.from
    fill_in "Mailbox", with: @mailbox_message.mailbox_id
    fill_in "Subject", with: @mailbox_message.subject
    click_on "Create Mailbox message"

    assert_text "Mailbox message was successfully created"
    click_on "Back"
  end

  test "should update Mailbox message" do
    visit mailbox_message_url(@mailbox_message)
    click_on "Edit this mailbox message", match: :first

    fill_in "Body raw", with: @mailbox_message.body_raw
    fill_in "From", with: @mailbox_message.from
    fill_in "Mailbox", with: @mailbox_message.mailbox_id
    fill_in "Subject", with: @mailbox_message.subject
    click_on "Update Mailbox message"

    assert_text "Mailbox message was successfully updated"
    click_on "Back"
  end

  test "should destroy Mailbox message" do
    visit mailbox_message_url(@mailbox_message)
    click_on "Destroy this mailbox message", match: :first

    assert_text "Mailbox message was successfully destroyed"
  end
end
