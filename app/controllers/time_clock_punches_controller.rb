class TimeClockPunchesController < InternalController
  before_action :set_time_clock_punch, only: %i[ show edit update destroy ]

  # GET /time_clock_punches
  def index
    @q = policy_scope(TimeClockPunch).ransack(params[:q])
    @time_clock_punches = @q.result(distinct: true).page(params[:page])
  end

  # GET /time_clock_punches/1
  def show
  end

  # GET /time_clock_punches/new
  def new
    @time_clock_punch = authorize TimeClockPunch.new
  end

  # GET /time_clock_punches/1/edit
  def edit
  end

  # POST /time_clock_punches
  def create
    @time_clock_punch = authorize TimeClockPunch.new(time_clock_punch_params)
    @time_clock_punch.created_by = current_user.person

    if @time_clock_punch.save
      redirect_to @time_clock_punch, notice: 'Time clock punch was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /time_clock_punches/1
  def update
    if @time_clock_punch.update(time_clock_punch_params)
      redirect_to @time_clock_punch, notice: 'Time clock punch was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /time_clock_punches/1
  def destroy
    @time_clock_punch.destroy!
    redirect_to time_clock_punches_url, notice: 'Time clock punch was successfully destroyed.', status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_clock_punch
      @time_clock_punch = authorize policy_scope(TimeClockPunch).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def time_clock_punch_params
      params.require(:time_clock_punch).permit(:start_time, :end_time, :person_id, :time_clock_period_id, :note)
    end
end
