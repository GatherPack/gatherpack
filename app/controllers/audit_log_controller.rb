class AuditLogController < ApplicationController
  before_action :set_version, only: %i[ show destroy ]
  before_action :check_for_admin

  def index
    @versions = PaperTrail::Version.all
  end

  def show
  end

  def destroy
    @version.destroy!
    redirect_to audit_log_index_path, notice: "Log was successfully destroyed.", status: :see_other
  end

  private

  def set_version
    @version = PaperTrail::Version.find(params[:id])
  end
end
