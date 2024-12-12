require "test_helper"

class RelationshipTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @relationship_type = relationship_types(:one)
  end

  test "should get index" do
    get relationship_types_url
    assert_response :success
  end

  test "should get new" do
    get new_relationship_type_url
    assert_response :success
  end

  test "should create relationship_type" do
    assert_difference("RelationshipType.count") do
      post relationship_types_url, params: { relationship_type: { child_label: @relationship_type.child_label, parent_label: @relationship_type.parent_label, permission: @relationship_type.permission } }
    end

    assert_redirected_to relationship_type_url(RelationshipType.last)
  end

  test "should show relationship_type" do
    get relationship_type_url(@relationship_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_relationship_type_url(@relationship_type)
    assert_response :success
  end

  test "should update relationship_type" do
    patch relationship_type_url(@relationship_type), params: { relationship_type: { child_label: @relationship_type.child_label, parent_label: @relationship_type.parent_label, permission: @relationship_type.permission } }
    assert_redirected_to relationship_type_url(@relationship_type)
  end

  test "should destroy relationship_type" do
    assert_difference("RelationshipType.count", -1) do
      delete relationship_type_url(@relationship_type)
    end

    assert_redirected_to relationship_types_url
  end
end
