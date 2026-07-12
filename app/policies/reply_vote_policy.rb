class ReplyVotePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(question_id: Question.where(team_id: person.all_teams.map(&:id)).select(:id))
      end
    end
  end

  def create?
    user.admin || person.all_teams.exists?(record.question&.team_id)
  end

  def upvote?
    create?
  end

  def destroy?
    create?
  end
end
