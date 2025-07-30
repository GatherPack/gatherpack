class SettingsController < ApplicationController
  before_action :check_for_admin

  def index
  end

  def update
    params[:settings].each do |key, val|
      Settings.set(key.to_sym, val)
    end
    redirect_to settings_path, notice: "Settings were successfully updated.", status: :see_other
  end
end
