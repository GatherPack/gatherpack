class CheckinsController < InternalController
  before_action :set_event
  before_action :set_checkin, only: %i[ show edit update destroy ]

  # GET /checkins/1
  def show
  end

  # GET /checkins/new
  def new
    @checkin = authorize @event.checkins.build
    @event.event_type.checkin_fields.each do |field|
      authorize @checkin.checkin_field_responses.build(checkin_field: field)
    end
  end

  # GET /checkins/1/edit
  def edit
  end

  # POST /checkins
  def create
    @checkin = authorize @event.checkins.build(checkin_params)

    if @checkin.save
      redirect_to @event, notice: 'Checkin was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /checkins/1
  def update
    if @checkin.update(checkin_params)
      redirect_to @checkin, notice: 'Checkin was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /checkins/1
  def destroy
    @checkin.destroy!
    redirect_to @event, notice: 'Checkin was successfully destroyed.', status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_checkin
      @checkin = policy_scope(@event.checkins).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def checkin_params
      params.require(:checkin).permit(:notes, :person_id, checkin_field_responses_attributes: [:id, :checkin_field_id, :response])
    end

    def set_event
      @event = policy_scope(Event).find(params[:event_id])
    end
end
