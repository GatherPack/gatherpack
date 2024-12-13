class ApplicationController < ActionController::Base
  include Pundit::Authorization
  around_action :set_time_zone

  before_action :set_paper_trail_whodunnit
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern # commenting this out may break javascript for some people...

  def admin?
    current_user&.admin
  end

  helper_method :admin?

  rescue_from Pundit::NotAuthorizedError, with: :pundit_not_authorized

  private

  def check_for_user
    redirect_to root_path, notice: 'You must be logged in to do that' unless current_user
  end

  def check_for_admin
    redirect_to root_path, notice: 'You are not allowed to do that' unless admin?
  end

  def pundit_not_authorized
    redirect_to root_path, notice: 'You are not allowed to do that'
  end

  def set_time_zone(&block)
    Time.use_zone(Settings[:time_zone].presence || 'UTC', &block)
  end
end
