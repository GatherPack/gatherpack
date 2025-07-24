require "application_system_test_case"

class GatewaysTest < ApplicationSystemTestCase
  setup do
    @gateway = gateways(:one)
  end

  test "visiting the index" do
    visit gateways_url
    assert_selector "h1", text: "Gateways"
  end

  test "should create gateway" do
    visit gateways_url
    click_on "New gateway"

    fill_in "Configuration", with: @gateway.configuration
    fill_in "Name", with: @gateway.name
    fill_in "Provides", with: @gateway.provides
    fill_in "Type", with: @gateway.type
    click_on "Create Gateway"

    assert_text "Gateway was successfully created"
    click_on "Back"
  end

  test "should update Gateway" do
    visit gateway_url(@gateway)
    click_on "Edit this gateway", match: :first

    fill_in "Configuration", with: @gateway.configuration
    fill_in "Name", with: @gateway.name
    fill_in "Provides", with: @gateway.provides
    fill_in "Type", with: @gateway.type
    click_on "Update Gateway"

    assert_text "Gateway was successfully updated"
    click_on "Back"
  end

  test "should destroy Gateway" do
    visit gateway_url(@gateway)
    click_on "Destroy this gateway", match: :first

    assert_text "Gateway was successfully destroyed"
  end
end
