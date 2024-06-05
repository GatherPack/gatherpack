require "application_system_test_case"

class TeamTypesTest < ApplicationSystemTestCase
  setup do
    @team_type = team_types(:one)
  end

  test "visiting the index" do
    visit team_types_url
    assert_selector "h1", text: "Team types"
  end

  test "should create team type" do
    visit team_types_url
    click_on "New team type"

    fill_in "Icon", with: @team_type.icon
    fill_in "Name", with: @team_type.name
    click_on "Create Team type"

    assert_text "Team type was successfully created"
    click_on "Back"
  end

  test "should update Team type" do
    visit team_type_url(@team_type)
    click_on "Edit this team type", match: :first

    fill_in "Icon", with: @team_type.icon
    fill_in "Name", with: @team_type.name
    click_on "Update Team type"

    assert_text "Team type was successfully updated"
    click_on "Back"
  end

  test "should destroy Team type" do
    visit team_type_url(@team_type)
    click_on "Destroy this team type", match: :first

    assert_text "Team type was successfully destroyed"
  end
end
