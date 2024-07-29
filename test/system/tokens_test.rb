require "application_system_test_case"

class TokensTest < ApplicationSystemTestCase
  setup do
    @token = tokens(:one)
  end

  test "visiting the index" do
    visit tokens_url
    assert_selector "h1", text: "Tokens"
  end

  test "should create token" do
    visit tokens_url
    click_on "New token"

    fill_in "People", with: @token.people_id
    fill_in "People type", with: @token.people_type
    fill_in "Value", with: @token.value
    click_on "Create Token"

    assert_text "Token was successfully created"
    click_on "Back"
  end

  test "should update Token" do
    visit token_url(@token)
    click_on "Edit this token", match: :first

    fill_in "People", with: @token.people_id
    fill_in "People type", with: @token.people_type
    fill_in "Value", with: @token.value
    click_on "Update Token"

    assert_text "Token was successfully updated"
    click_on "Back"
  end

  test "should destroy Token" do
    visit token_url(@token)
    click_on "Destroy this token", match: :first

    assert_text "Token was successfully destroyed"
  end
end
