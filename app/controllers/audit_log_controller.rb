class AuditLogController < ApplicationController
  before_action :check_for_admin
  before_action :set_log, only: %i[ show destroy revert ]

  def index
    @q = Version.all.ransack(params[:q])
    @logs = @q.result(distinct: true).order(created_at: :desc).page(params[:page])
  end

  def show
    @log_hash = PaperTrail.serializer.load(@log.object_changes)
  end

  def destroy
    @log.destroy!

    respond_to do |format|
      format.html { redirect_to audit_log_index_url, notice: "Log was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def revert
    @log.reify&.save

    respond_to do |format|
      format.html { redirect_to audit_log_index_url, notice: "Successfully reverted to version #{@log.created_at}." }
      format.json { head :no_content }
    end
  end

  private

  def set_log
    @log = Version.all.find(params[:id])
  end
end
