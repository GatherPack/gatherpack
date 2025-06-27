class EventsController < InternalController
  before_action :set_event, only: %i[ show edit update destroy arrange print ]

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

  def arrange
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
    redirect_to events_url, notice: "Event was successfully destroyed.", status: :see_other
  end

  def calendar
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json do
        ransacked_events = policy_scope(Event).ransack(params[:q]).result(distinct: true)
        ransacked_people = policy_scope(Person).ransack(
          display_name_i_cont: params[:q][:name_i_cont]
        ).result(distinct: true)
        ransacked_people = ransacked_people.joins(:memberships).where(memberships: { team_id: params[:q][:team_id_eq] }) if params[:q][:team_id_eq].present?

        start_time = params[:start_time]
        end_time = params[:end_time]
        start_time_doy = Date.parse(start_time).yday
        end_time_doy = Date.parse(end_time).yday
        start_time_year = Date.parse(start_time).year
        end_time_year = Date.parse(end_time).year

        events = ransacked_events.where("start_time >= ? AND start_time <= ?", start_time, end_time)
          .or(ransacked_events.where("start_time <= ? AND end_time >= ?", start_time, start_time))
        birthdays = ransacked_people.where("DATE_PART('doy', birthday) >= ? AND DATE_PART('doy', birthday) <= ? AND DATE_PART('year', birthday) <= ?", start_time_doy >= end_time_doy ? 0 : start_time_doy, end_time_doy, start_time_year)
          .or(ransacked_people.where("DATE_PART('doy', birthday) >= ? AND DATE_PART('doy', birthday) <= ? AND DATE_PART('year', birthday) <= ?", start_time_doy >= end_time_doy ? start_time_doy : 367, 366, start_time_year))

        render json: Jbuilder.new { |json|
          json.array! events do |event|
            background_color = event.team&.color || "#3788d8"
            json.id event.id
            json.title event.name
            json.allDay false
            json.start event.start_time
            json.end event.end_time
            json.url event_url(event)
            json.backgroundColor background_color
            json.textColor Color::RGB.by_hex(background_color).brightness > 0.5 ? "#6d6753" : "#fffdf6"

            json.extendedProps do
              json.icon "fa-" + (event.team&.team_type&.icon || "star")
            end
          end

          json.array! birthdays do |person|
            json.id person.id
            json.title "#{person.identifier_name}'s Birthday"
            json.allDay true
            json.start person.birthday.change(year: (person.birthday.yday - start_time_doy < 0 ? end_time_year : start_time_year))
            json.end nil
            json.url person_url(person)
            json.backgroundColor "#3788d8"
            json.textColor "#fffdf6"

            json.extendedProps do
              json.icon "fa-cake-candles"
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
      params.require(:event).permit(:name, :description, :start_time, :end_time, :location, :event_type_id, :team_id, :locked, :time_clock_period_id, :checkin_limit)
    end
end
