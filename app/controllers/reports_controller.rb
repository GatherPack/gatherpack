class ReportsController < InternalController
  before_action :set_report, only: %i[ show run edit update destroy ]

  # GET /reports
  def index
    @q = Report.ransack(params[:q])
    @reports = @q.result(distinct: true).page(params[:page])
  end

  # GET /reports/1
  def show
  end

  # GET /reports/1/run
  def run
    @results = JSON.pretty_generate(eval(@report.code))
  end

  # GET /reports/new
  def new
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports
  def create
    @report = Report.new(report_params)

    if @report.save
      redirect_to @report, notice: 'Report was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reports/1
  def update
    if @report.update(report_params)
      redirect_to @report, notice: 'Report was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /reports/1
  def destroy
    @report.destroy!
    redirect_to reports_url, notice: 'Report was successfully destroyed.', status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def report_params
      params.require(:report).permit(:name, :code)
    end
end
