require "test_helper"

class ReplyPolicyTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @reply = replies(:one)
  end

  test "scope returns replies for user's teams" do
    scoped = ReplyPolicy::Scope.new(@user, Reply).resolve
    assert_includes scoped, @reply
  end

  test "create requires team membership" do
    policy = ReplyPolicy.new(@user, @reply)
    assert policy.create?
  end

  test "update as author" do
    policy = ReplyPolicy.new(@user, @reply)
    assert policy.update?
  end

  test "destroy requires admin or manager" do
    policy = ReplyPolicy.new(@user, @reply)
    # Destroy requires admin or manager of the question's team
    if @user.admin?
      assert policy.destroy?
    else
      assert_not policy.destroy?
    end
  end
end
