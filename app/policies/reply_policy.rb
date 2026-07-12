class ReplyPolicy < ApplicationPolicy
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

  def update?
    user.admin || record.person_id == person.id || manager_of_question_team?(record.question)
  end

  def destroy?
    user.admin || manager_of_question_team?(record.question)
  end

  private

  def manager_of_question_team?(question)
    question&.team && person.all_managed_teams.include?(question.team)
  end
end
