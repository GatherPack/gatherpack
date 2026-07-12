require "test_helper"

class ReplyPolicyTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @reply = replies(:one)
  end

  test "scope returns replies for user's teams" do
    policy = ReplyPolicy.new(@user, Reply)
    scoped = policy.scope.resolve
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
    assert @user.admin? || policy.destroy?
  end
end
