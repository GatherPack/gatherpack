class EventsController < InternalController
  before_action :set_event, only: %i[ show edit update destroy ]

  # GET /events
  def index
    @q = policy_scope(Event).ransack(params[:q])
    @events = @q.result(distinct: true).page(params[:page]).includes(:event_type)
  end

  # GET /events/1
  def show
    @q = policy_scope(@event.checkins).ransack(params[:q])
    @checkins = @q.result(distinct: true).page(params[:page])
    @checkin = @event.checkins.build
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
    redirect_to events_url, notice: "Event was successfully destroyed.", status: :see_other
  end

  def get_events
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json do
        start_time = params[:start_time]
        end_time = params[:end_time]
        events = policy_scope(Event).where("start_time >= ? AND start_time <= ?", start_time, end_time).or(policy_scope(Event).where("end_time >= ? AND end_time <= ?", start_time, end_time))

        render json: Jbuilder.new { |json|
          json.array! events do |event|
            json.id event.id
            json.name event.name
            json.start_time event.start_time
            json.end_time event.end_time

            json.team do |team|
              team.name event.team.name
              team.color event.team.color
              team.team_type do |team_type|
                team_type.icon event.team.team_type.icon
              end
            end
          end
        }.target!
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:name, :description, :start_time, :end_time, :location, :event_type_id, :team_id, :locked)
    end
end
