require 'application_system_test_case'

class VariablesTest < ApplicationSystemTestCase
  setup do
    @variable = variables(:one)
  end

  test 'visiting the index' do
    visit variables_url
    assert_selector 'h1', text: 'Variables'
  end

  test 'should create variable' do
    visit variables_url
    click_on 'New variable'

    fill_in 'Klass', with: @variable.klass
    fill_in 'Name', with: @variable.name
    fill_in 'Raw value', with: @variable.raw_value
    click_on 'Create Variable'

    assert_text 'Variable was successfully created'
    click_on 'Back'
  end

  test 'should update Variable' do
    visit variable_url(@variable)
    click_on 'Edit this variable', match: :first

    fill_in 'Klass', with: @variable.klass
    fill_in 'Name', with: @variable.name
    fill_in 'Raw value', with: @variable.raw_value
    click_on 'Update Variable'

    assert_text 'Variable was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Variable' do
    visit variable_url(@variable)
    click_on 'Destroy this variable', match: :first

    assert_text 'Variable was successfully destroyed'
  end
end
