class BadgeAssignmentsController < ApplicationController
  def index
    @badge = policy_scope(Badge).find(params[:badge_id])
  end
end
