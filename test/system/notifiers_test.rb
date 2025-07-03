require "application_system_test_case"

class NotifiersTest < ApplicationSystemTestCase
  setup do
    @notifier = notifiers(:one)
  end

  test "visiting the index" do
    visit notifiers_url
    assert_selector "h1", text: "Notifiers"
  end

  test "should create notifier" do
    visit notifiers_url
    click_on "New notifier"

    fill_in "Person", with: @notifier.person_id
    fill_in "Schedule", with: @notifier.schedule
    fill_in "Scope", with: @notifier.scope
    fill_in "Target", with: @notifier.target
    click_on "Create Notifier"

    assert_text "Notifier was successfully created"
    click_on "Back"
  end

  test "should update Notifier" do
    visit notifier_url(@notifier)
    click_on "Edit this notifier", match: :first

    fill_in "Person", with: @notifier.person_id
    fill_in "Schedule", with: @notifier.schedule
    fill_in "Scope", with: @notifier.scope
    fill_in "Target", with: @notifier.target
    click_on "Update Notifier"

    assert_text "Notifier was successfully updated"
    click_on "Back"
  end

  test "should destroy Notifier" do
    visit notifier_url(@notifier)
    click_on "Destroy this notifier", match: :first

    assert_text "Notifier was successfully destroyed"
  end
end
