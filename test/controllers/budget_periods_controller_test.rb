require "test_helper"

class BudgetPeriodsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @budget_period = budget_periods(:one)
  end

  test "should get index" do
    get budget_periods_url
    assert_response :success
  end

  test "should get new" do
    get new_budget_period_url
    assert_response :success
  end

  test "should create budget_period" do
    assert_difference("BudgetPeriod.count") do
      post budget_periods_url, params: { budget_period: { ends_at: @budget_period.ends_at, name: @budget_period.name, starts_at: @budget_period.starts_at } }
    end

    assert_redirected_to budget_period_url(BudgetPeriod.last)
  end

  test "should show budget_period" do
    get budget_period_url(@budget_period)
    assert_response :success
  end

  test "should get edit" do
    get edit_budget_period_url(@budget_period)
    assert_response :success
  end

  test "should update budget_period" do
    patch budget_period_url(@budget_period), params: { budget_period: { ends_at: @budget_period.ends_at, name: @budget_period.name, starts_at: @budget_period.starts_at } }
    assert_redirected_to budget_period_url(@budget_period)
  end

  test "should destroy budget_period" do
    assert_difference("BudgetPeriod.count", -1) do
      delete budget_period_url(@budget_period)
    end

    assert_redirected_to budget_periods_url
  end
end
