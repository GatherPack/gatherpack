class BadgeAssignmentsController < ApplicationController
  def index
    @badge = policy_scope(Badge).find(params[:badge_id])
    @people = if admin? || current_user.person.all_managed_teams.include?(@badge.team)
      @badge.team ? @badge.team.people : Person.all
    else
      case @badge.permission
      when "added_by_current_member"
        @badge.team.people
      when "has_account"
        @badge.team ? @badge.team.people : Person.all
      when "added_by_manager_or_self"
        @badge.team.people.where(id: current_user.person.id)
      when "added_by_admin_or_self"
        @badge.team.people.where(id: current_user.person.id)
      end
    end.order(last_name: :asc, first_name: :asc)
  end
end
