class AuditLogsController < ApplicationController
  before_action :check_for_admin
  before_action :set_log, only: %i[ show destroy revert ]

  def index
    @q = AuditLog.ransack(params[:q])
    @logs = authorize @q.result(distinct: true).order(created_at: :desc).page(params[:page])
  end

  def show
    @log_hash = PaperTrail.serializer.load(@log.object_changes)
  end

  def destroy
    @log.destroy!

    respond_to do |format|
      format.html { redirect_to audit_logs_url, notice: "Log was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def revert
    @log.reify&.save

    respond_to do |format|
      format.html { redirect_to audit_logs_url, notice: "Successfully reverted to version #{@log.created_at}." }
      format.json { head :no_content }
    end
  end

  private

  def set_log
    @log = authorize AuditLog.find(params[:id])
  end
end
