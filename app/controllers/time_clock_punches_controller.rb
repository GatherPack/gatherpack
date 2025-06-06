class TimeClockPunchesController < InternalController
  before_action :set_time_clock_punch, only: %i[ edit update destroy ]
  before_action :set_time_clock_period_scope, only: %i[ new create edit update ]

  # GET /time_clock_punches
  def index
    @q = policy_scope(TimeClockPunch).ransack(params[:q])
    @q.sorts = "start_time desc" if @q.sorts.empty?
    @time_clock_punches = @q.result(distinct: true).includes(:person).order(start_time: :desc, end_time: :desc).page(params[:page])
    @time_clock_punches.each do |punch|
      if policy(punch).edit?
        @has_editable_punches = true
        break
      end
    end
    @has_editable_punches ||= false
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
      redirect_to time_clock_punches_path, notice: "Time clock punch was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /time_clock_punches/1
  def update
    @time_clock_punch.created_by = current_user.person
    if @time_clock_punch.update(time_clock_punch_params)
      redirect_to time_clock_punches_path, notice: "Time clock punch was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /time_clock_punches/1
  def destroy
    @time_clock_punch.destroy!
    redirect_to time_clock_punches_url, notice: "Time clock punch was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_clock_punch
      @time_clock_punch = authorize policy_scope(TimeClockPunch).find(params[:id])
    end

    def set_time_clock_period_scope
      @time_clock_periods = policy_scope(TimeClockPeriod)
      unless current_user.admin?
        # keep: periods of teams that they manage with 'added_by_manager' perms, periods of teams that they are in with 'added_by_team_member/user' perms, generic periods with 'added_by_manager/team_member/user' perms)
        # remove: periods of teams they are in or generic teams with 'added_by_admin' perms
        @time_clock_periods = @time_clock_periods.reject { |period| period.permission == "added_by_admin" }
        # periods of teams they are in and don't manage with 'added_by_manager' perms
        @time_clock_periods = @time_clock_periods.reject { |period| period.permission == "added_by_manager" && current_user.person.all_managed_teams.exclude?(period.team) }
        # periods of teams they are not in
        @time_clock_periods = @time_clock_periods.reject { |period| current_user.person.teams.exclude?(period.team) }
      end
    end

    # Only allow a list of trusted parameters through.
    def time_clock_punch_params
      params.require(:time_clock_punch).permit(:start_time, :end_time, :person_id, :time_clock_period_id, :note)
    end
end
