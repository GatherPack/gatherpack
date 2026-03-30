class TimeClockPeriodsController < InternalController
  before_action :set_time_clock_period, only: %i[ show summary edit update destroy ]
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

  def summary
    time_zone = Settings[:time_zone].presence || "UTC"

    punches = policy_scope(TimeClockPunch)
      .where(time_clock_period: @time_clock_period)
      .where.not(end_time: nil)

    starts_at = params[:starts_at].presence || @time_clock_period.start_time.in_time_zone(time_zone).to_date.beginning_of_day.iso8601
    ends_at   = params[:ends_at].presence || @time_clock_period.end_time.in_time_zone(time_zone).to_date.end_of_day.iso8601

    if params[:starts_at].present?
      starts_at = Time.zone.parse(params[:starts_at])
      punches = punches.where("start_time >= ?", starts_at)
    end

    if params[:ends_at].present?
      ends_at = Time.zone.parse(params[:ends_at])
      punches = punches.where("start_time <= ?", ends_at)
    end

    @start_date = starts_at.to_date
    @end_date   = ends_at.to_date

    @daily_stats = (@start_date..@end_date).each_with_object({}) do |date, h|
      h[date] = { hours: 0.0, people: Set.new }
    end

    punches.each do |punch|
      day = punch.start_time.in_time_zone(time_zone).to_date
      @daily_stats[day] ||= { hours: 0.0, people: Set.new }
      @daily_stats[day][:hours] += punch.hours
      @daily_stats[day][:people] << punch.person_id
    end

    @daily_stats.transform_values! { |v| { hours: v[:hours].round(2), people: v[:people].size } }

    @total_hours  = @daily_stats.sum { |_, v| v[:hours] }.round(2)
    @people = punches.includes(:person).map(&:person).uniq
    @total_people = @people.size

    @calendar_events = @daily_stats.filter_map do |date, stats|
      next if stats[:hours].zero?
      {
        title: "#{stats[:hours]} hrs · #{stats[:people]} #{"person".pluralize(stats[:people])}",
        start: date.iso8601,
        allDay: true,
        backgroundColor: "#0d6efd",
        borderColor: "#0a58ca",
        textColor: "#ffffff",
        extendedProps: { icon: "fa-clock" }
      }
    end
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
      redirect_to @time_clock_period, notice: "Time clock period was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /time_clock_periods/1
  def update
    if @time_clock_period.update(time_clock_period_params)
      redirect_to @time_clock_period, notice: "Time clock period was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /time_clock_periods/1
  def destroy
    @time_clock_period.destroy!
    redirect_to time_clock_periods_url, notice: "Time clock period was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_clock_period
      @time_clock_period = authorize policy_scope(TimeClockPeriod).find(params[:id])
    end

    def permission_keys
      @permissions_keys = TimeClockPeriod.permissions.keys.reject { |key| key == "added_by_admin" unless current_user.admin }.reject { |key| key == "added_by_manager" unless current_user.person.manager? }
    end

    # Only allow a list of trusted parameters through.
    def time_clock_period_params
      params.require(:time_clock_period).permit(:name, :start_time, :end_time, :permission, :team_id)
    end
end
