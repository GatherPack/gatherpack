require "application_system_test_case"

class RelationshipTypesTest < ApplicationSystemTestCase
  setup do
    @relationship_type = relationship_types(:one)
  end

  test "visiting the index" do
    visit relationship_types_url
    assert_selector "h1", text: "Relationship types"
  end

  test "should create relationship type" do
    visit relationship_types_url
    click_on "New relationship type"

    fill_in "Child label", with: @relationship_type.child_label
    fill_in "Parent label", with: @relationship_type.parent_label
    fill_in "Permission", with: @relationship_type.permission
    click_on "Create Relationship type"

    assert_text "Relationship type was successfully created"
    click_on "Back"
  end

  test "should update Relationship type" do
    visit relationship_type_url(@relationship_type)
    click_on "Edit this relationship type", match: :first

    fill_in "Child label", with: @relationship_type.child_label
    fill_in "Parent label", with: @relationship_type.parent_label
    fill_in "Permission", with: @relationship_type.permission
    click_on "Update Relationship type"

    assert_text "Relationship type was successfully updated"
    click_on "Back"
  end

  test "should destroy Relationship type" do
    visit relationship_type_url(@relationship_type)
    click_on "Destroy this relationship type", match: :first

    assert_text "Relationship type was successfully destroyed"
  end
end
