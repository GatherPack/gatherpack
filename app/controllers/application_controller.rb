class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  def pundit_user
    current_user.person
  end

  def admin?
    current_user&.admin
  end

  helper_method :admin?

  private

  def check_for_user
    redirect_to root_path, notice: 'You must be logged in to do that' unless current_user
  end

  def check_for_admin
    redirect_to root_path, notice: 'You are not allowed to do that' unless admin?
  end
end
