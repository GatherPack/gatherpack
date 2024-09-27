require "application_system_test_case"

class HooksTest < ApplicationSystemTestCase
  setup do
    @hook = hooks(:one)
  end

  test "visiting the index" do
    visit hooks_url
    assert_selector "h1", text: "Hooks"
  end

  test "should create hook" do
    visit hooks_url
    click_on "New hook"

    fill_in "Code", with: @hook.code
    fill_in "Event", with: @hook.event
    fill_in "Name", with: @hook.name
    click_on "Create Hook"

    assert_text "Hook was successfully created"
    click_on "Back"
  end

  test "should update Hook" do
    visit hook_url(@hook)
    click_on "Edit this hook", match: :first

    fill_in "Code", with: @hook.code
    fill_in "Event", with: @hook.event
    fill_in "Name", with: @hook.name
    click_on "Update Hook"

    assert_text "Hook was successfully updated"
    click_on "Back"
  end

  test "should destroy Hook" do
    visit hook_url(@hook)
    click_on "Destroy this hook", match: :first

    assert_text "Hook was successfully destroyed"
  end
end
