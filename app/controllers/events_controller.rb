class EventsController < InternalController
  before_action :set_event, only: %i[ show edit update destroy arrange print duplicate duplicate_create ]

  # GET /events
  def index
    @q = policy_scope(Event).ransack(params[:q])
    @q.sorts = "name asc" if @q.sorts.empty?
    @events = @q.result(distinct: true).page(params[:page]).includes(:event_type)
  end

  # GET /events/1
  def show
    @q = policy_scope(@event.checkins).ransack(params[:q])
    @checkins = @q.result(distinct: true).page(params[:page])
    @checkin = @event.checkins.build
  end

  def arrange
    @event.checkins.each(&:refresh_fields)
    @field = CheckinField.find(params[:field_id]) rescue nil
    @responses = CheckinFieldResponse
      .includes(checkin: :person)
      .joins(:checkin)
      .where(checkin_field: @field, checkins: { event_id: @event.id })
  end

  def print
    @event.checkins.each(&:refresh_fields)
    @field = CheckinField.find(params[:field_id]) rescue nil
    @possible_values = @event.checkin_field_responses.where(checkin_field: @field).distinct.pluck(:response).compact.sort_by { |v| v || "zzzzz" }
    @values = params[:values].present? ? @possible_values & params[:values] : @possible_values
    @values = @possible_values if @values.empty?
    @paged = params[:paged] == "true"
    @notes = params[:notes] == "true"
    @responses = CheckinFieldResponse
      .includes(checkin: :person)
      .joins(:checkin)
      .where(checkin_field: @field, checkins: { event_id: @event.id })
    @last_updated = @responses.maximum(:updated_at)
  end

  # GET /events/new
  def new
    @event = authorize Event.new
  end

  # GET /events/1/duplicate
  def duplicate
  end

  # POST /events/1/duplicate
  def duplicate_create
    dates = Array(params[:dates]).filter_map { |d| Date.iso8601(d) rescue nil }.uniq.sort

    if dates.empty?
      redirect_to duplicate_event_path(@event), alert: "Select at least one date."
      return
    end

    duration = @event.end_time.present? ? @event.end_time - @event.start_time : nil
    copies = ActiveRecord::Base.transaction do
      dates.map do |date|
        copy = @event.dup
        copy.start_time = @event.start_time.change(year: date.year, month: date.month, day: date.day)
        copy.end_time = duration ? copy.start_time + duration : nil
        copy.save!
        copy
      end
    end

    redirect_to events_path(q: { name_i_cont: @event.name }), notice: "Created #{helpers.pluralize(copies.size, "copy")} of #{@event.name}."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to duplicate_event_path(@event), alert: "Duplication failed: #{e.message}"
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  def create
    @event = authorize Event.new(event_params)

    if @event.save
      redirect_to @event, notice: "Event was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      redirect_to @event, notice: "Event was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy!
    redirect_to calendar_index_url, notice: "Event was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = authorize Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:name, :description, :start_time, :end_time, :location, :event_type_id, :team_id, :locked, :time_clock_period_id, :checkin_limit)
    end
end
