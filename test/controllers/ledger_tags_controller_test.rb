require "test_helper"

class LedgerTagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ledger_tag = ledger_tags(:one)
  end

  test "should get index" do
    get ledger_tags_url
    assert_response :success
  end

  test "should get new" do
    get new_ledger_tag_url
    assert_response :success
  end

  test "should create ledger_tag" do
    assert_difference("LedgerTag.count") do
      post ledger_tags_url, params: { ledger_tag: { name: @ledger_tag.name } }
    end

    assert_redirected_to ledger_tag_url(LedgerTag.last)
  end

  test "should show ledger_tag" do
    get ledger_tag_url(@ledger_tag)
    assert_response :success
  end

  test "should get edit" do
    get edit_ledger_tag_url(@ledger_tag)
    assert_response :success
  end

  test "should update ledger_tag" do
    patch ledger_tag_url(@ledger_tag), params: { ledger_tag: { name: @ledger_tag.name } }
    assert_redirected_to ledger_tag_url(@ledger_tag)
  end

  test "should destroy ledger_tag" do
    assert_difference("LedgerTag.count", -1) do
      delete ledger_tag_url(@ledger_tag)
    end

    assert_redirected_to ledger_tags_url
  end
end
