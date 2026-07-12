require "test_helper"

class ReplyVoteTest < ActiveSupport::TestCase
  fixtures :users, :people, :teams, :team_types, :memberships, :questions, :replies, :reply_votes

  setup do
    @vote = reply_votes(:one)
  end

  test "valid vote" do
    assert @vote.valid?
  end

  test "requires reply" do
    @vote.reply = nil
    assert_not @vote.valid?
  end

  test "requires person" do
    @vote.person = nil
    assert_not @vote.valid?
  end

  test "requires question" do
    @vote.question = nil
    assert_not @vote.valid?
  end

  test "one vote per person per question" do
    person = people(:two)
    question = questions(:one)

    existing = ReplyVote.find_by(person: person, question: question)
    assert existing.present?, "Expected existing vote"

    duplicate = ReplyVote.new(person: person, question: question, reply: replies(:two))
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:person_id], "has already been taken"
  end

  test "can vote on different questions" do
    person = people(:one)
    question_two = questions(:two)

    vote = ReplyVote.new(person: person, question: question_two, reply: replies(:one))
    vote.question = question_two
    assert vote.valid?
  end

  test "reply must belong to question" do
    question_two = questions(:two)
    vote = ReplyVote.new(person: people(:one), reply: replies(:one), question: question_two)
    assert_not vote.valid?
    assert_includes vote.errors[:reply], "must belong to this question"
  end
end
