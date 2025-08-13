class ApplicationController < ActionController::Base
  include Pundit::Authorization
  impersonates :user

  around_action :set_time_zone
  before_action :set_paper_trail_whodunnit

  def admin?
    current_user&.admin
  end

  def architect?
    current_user&.architect
  end

  def manager?
    current_user&.person&.manager?
  end

  helper_method :admin?, :architect?, :manager?

  rescue_from Pundit::NotAuthorizedError, with: :pundit_not_authorized

  private

  def check_for_user
    unless current_user
      session[:user_return_to] = request.fullpath if request.get? && !request.xhr?
      redirect_to new_user_session_path, notice: "You must be logged in to do that"
    end
  end

  def after_sign_up_path_for(resource)
    session.delete(:user_return_to) || stored_location_for(resource) || root_path
  end

  def check_for_admin
    redirect_to root_path, notice: "You are not allowed to do that" unless admin?
  end

  def check_for_architect
    redirect_to root_path, notice: "You are not allowed to do that" unless architect?
  end

  def pundit_not_authorized
    redirect_back_or_to root_path, notice: "You are not allowed to do that"
  end

  def set_time_zone(&block)
    Time.use_zone(Settings[:time_zone].presence || "UTC", &block)
  end

  def user_for_paper_trail
    true_user&.id
  end
end
