class WelcomeController < ApplicationController
  def index
    if user_signed_in?
      render :dashboard
    else
      redirect_to new_user_session_path
    end
  end

  def setup
  end
end
