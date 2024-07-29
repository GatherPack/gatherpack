class AuditLogController < ApplicationController
  before_action :set_version, only: %i[ show destory revert ]
  before_action :check_for_admin

  def index
    @versions = PaperTrail::Version.all
  end

  def show
  end

  def destory
  end

  def revert
  end

  private

  def set_version
    @version = PaperTrail::Version.find(params[:id])
  end
end
