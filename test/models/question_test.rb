require "test_helper"

class QuestionTest < ActiveSupport::TestCase
  fixtures :users, :people, :teams, :team_types, :memberships, :questions, :replies, :reply_votes

  setup do
    @question = questions(:one)
  end

  test "valid question" do
    assert @question.valid?
  end

  test "requires title" do
    @question.title = nil
    assert_not @question.valid?
    assert_includes @question.errors[:title], "can't be blank"
  end

  test "requires content" do
    @question.content = nil
    assert_not @question.valid?
    assert_includes @question.errors[:content], "can't be blank"
  end

  test "requires team" do
    @question.team = nil
    assert_not @question.valid?
  end

  test "requires person" do
    @question.person = nil
    assert_not @question.valid?
  end

  test "closed scope" do
    @question.update!(closed: true)
    assert_includes Question.closed_questions, @question
    assert_not_includes Question.open_questions, @question
  end

  test "open scope" do
    assert_includes Question.open_questions, @question
    assert_not_includes Question.closed_questions, @question
  end

  test "promoted_replies returns top voted replies" do
    promoted = @question.promoted_replies(limit: 3)
    assert_includes promoted, replies(:one)
    assert_includes promoted, replies(:two)
  end

  test "voted_reply_for returns person's voted reply" do
    person = people(:two)
    voted = @question.voted_reply_for(person)
    assert_equal replies(:one), voted
  end

  test "vote_counts returns hash of reply_id => count" do
    counts = @question.vote_counts
    assert_equal 1, counts[replies(:one).id]
    assert_equal 1, counts[replies(:two).id]
  end

  test "has neat_id" do
    assert @question.neat_id.present?
    assert @question.neat_id.to_s.start_with?("qst_")
  end
end
