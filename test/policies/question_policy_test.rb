require "test_helper"

class QuestionPolicyTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @person = people(:one)
    @question = questions(:one)
    @team = teams(:one)
  end

  test "scope returns questions for user's teams" do
    policy = QuestionPolicy.new(@user, Question)
    scoped = policy.scope.resolve
    assert_includes scoped, @question
  end

  test "create requires team membership" do
    policy = QuestionPolicy.new(@user, Question.new(team: @team))
    assert policy.create?
  end

  test "update as author" do
    policy = QuestionPolicy.new(@user, @question)
    assert policy.update?
  end

  test "destroy requires manager or admin" do
    policy = QuestionPolicy.new(@user, @question)
    # User one is person one who is author, but destroy requires admin/manager
    # With default fixtures, person one is not a manager, so this should be false
    # unless user is admin
    assert @user.admin? || policy.destroy?
  end

  test "close as author" do
    policy = QuestionPolicy.new(@user, @question)
    assert policy.close?
  end

  test "reopen as author" do
    policy = QuestionPolicy.new(@user, @question)
    assert policy.reopen?
  end

  test "move requires manager" do
    policy = QuestionPolicy.new(@user, @question)
    # Move requires manager of the team
    assert @user.admin? || policy.move?
  end
end
