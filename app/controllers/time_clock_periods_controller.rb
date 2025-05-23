class TimeClockPeriodsController < InternalController
  before_action :set_time_clock_period, only: %i[ show edit update destroy ]
  before_action :permission_keys, only: %i[ new create edit update ]

  # GET /time_clock_periods
  def index
    @q = policy_scope(TimeClockPeriod).ransack(params[:q])
    @q.sorts = "start_time desc" if @q.sorts.empty?
    @time_clock_periods = @q.result(distinct: true).order(start_time: :desc, end_time: :desc, name: :asc).page(params[:page])
  end

  # GET /time_clock_periods/1
  def show
    @q = policy_scope(TimeClockPunch).where(time_clock_period: @time_clock_period).ransack(params[:q])
    @time_clock_punches = @q.result(distinct: true).includes(:person).order(start_time: :desc, end_time: :desc).page(params[:page])
    @time_clock_punches.each do |punch|
      if policy(punch).edit?
        @has_editable_punches = true
        break
      end
    end
    @has_editable_punches ||= false
  end

  # GET /time_clock_periods/new
  def new
    @time_clock_period = authorize TimeClockPeriod.new
  end

  # GET /time_clock_periods/1/edit
  def edit
  end

  # POST /time_clock_periods
  def create
    @time_clock_period = authorize TimeClockPeriod.new(time_clock_period_params)

    if @time_clock_period.save
      redirect_to @time_clock_period, notice: 'Time clock period was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /time_clock_periods/1
  def update
    if @time_clock_period.update(time_clock_period_params)
      redirect_to @time_clock_period, notice: 'Time clock period was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /time_clock_periods/1
  def destroy
    @time_clock_period.destroy!
    redirect_to time_clock_periods_url, notice: 'Time clock period was successfully destroyed.', status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_clock_period
      @time_clock_period = authorize policy_scope(TimeClockPeriod).find(params[:id])
    end

    def permission_keys
      @permissions_keys = TimeClockPeriod.permissions.keys.reject { |key| key == 'added_by_admin' unless current_user.admin }.reject { |key| key == 'added_by_manager' unless current_user.person.manager? }
    end

    # Only allow a list of trusted parameters through.
    def time_clock_period_params
      params.require(:time_clock_period).permit(:name, :start_time, :end_time, :permission, :team_id)
    end
end
