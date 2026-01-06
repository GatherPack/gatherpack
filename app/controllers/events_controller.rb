class EventsController < InternalController
  before_action :set_event, only: %i[ show edit update destroy arrange print ]

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
    @field = CheckinField.find(params[:field_id]) rescue nil
    @responses = CheckinFieldResponse
      .includes(checkin: :person)
      .joins(:checkin)
      .where(checkin_field: @field, checkins: { event_id: @event.id })
  end

  # GET /events/new
  def new
    @event = authorize Event.new
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
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:name, :description, :start_time, :end_time, :location, :event_type_id, :team_id, :locked, :time_clock_period_id, :checkin_limit)
    end
end
