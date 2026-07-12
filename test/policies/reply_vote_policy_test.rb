require "test_helper"

class ReplyVotePolicyTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @vote = reply_votes(:one)
  end

  test "scope returns votes for user's teams" do
    policy = ReplyVotePolicy.new(@user, ReplyVote)
    scoped = policy.scope.resolve
    assert_includes scoped, @vote
  end

  test "create requires team membership" do
    policy = ReplyVotePolicy.new(@user, @vote)
    assert policy.create?
  end

  test "destroy requires team membership" do
    policy = ReplyVotePolicy.new(@user, @vote)
    assert policy.destroy?
  end
end
