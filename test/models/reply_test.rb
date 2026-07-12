require "test_helper"

class ReplyTest < ActiveSupport::TestCase
  fixtures :users, :people, :teams, :team_types, :memberships, :questions, :replies, :reply_votes

  setup do
    @reply = replies(:one)
  end

  test "valid reply" do
    assert @reply.valid?
  end

  test "requires content" do
    @reply.content = nil
    assert_not @reply.valid?
    assert_includes @reply.errors[:content], "can't be blank"
  end

  test "requires question" do
    @reply.question = nil
    assert_not @reply.valid?
  end

  test "requires person" do
    @reply.person = nil
    assert_not @reply.valid?
  end

  test "top_level scope excludes child replies" do
    top_level = Reply.top_level
    assert_includes top_level, replies(:one)
    assert_includes top_level, replies(:two)
    assert_not_includes top_level, replies(:three)
  end

  test "children association" do
    assert_includes replies(:one).children, replies(:three)
  end

  test "parent association" do
    assert_equal replies(:one), replies(:three).parent
  end

  test "vote_count returns number of votes" do
    assert_equal 1, replies(:one).vote_count
    assert_equal 1, replies(:two).vote_count
    assert_equal 0, replies(:three).vote_count
  end

  test "has neat_id" do
    assert @reply.neat_id.present?
    assert @reply.neat_id.to_s.start_with?("rpl_")
  end
end
