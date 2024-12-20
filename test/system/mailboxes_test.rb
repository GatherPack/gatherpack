require "application_system_test_case"

class MailboxesTest < ApplicationSystemTestCase
  setup do
    @mailbox = mailboxes(:one)
  end

  test "visiting the index" do
    visit mailboxes_url
    assert_selector "h1", text: "Mailboxes"
  end

  test "should create mailbox" do
    visit mailboxes_url
    click_on "New mailbox"

    fill_in "Address", with: @mailbox.address
    click_on "Create Mailbox"

    assert_text "Mailbox was successfully created"
    click_on "Back"
  end

  test "should update Mailbox" do
    visit mailbox_url(@mailbox)
    click_on "Edit this mailbox", match: :first

    fill_in "Address", with: @mailbox.address
    click_on "Update Mailbox"

    assert_text "Mailbox was successfully updated"
    click_on "Back"
  end

  test "should destroy Mailbox" do
    visit mailbox_url(@mailbox)
    click_on "Destroy this mailbox", match: :first

    assert_text "Mailbox was successfully destroyed"
  end
end
