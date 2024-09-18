class EventTypesController < InternalController
  before_action :set_event_type, only: %i[ show edit update destroy ]
  before_action :check_for_admin

  # GET /event_types
  def index
    @q = EventType.ransack(params[:q])
    @event_types = @q.result(distinct: true).page(params[:page]).includes(:events)
  end

  # GET /event_types/1
  def show
  end

  # GET /event_types/new
  def new
    @event_type = EventType.new
  end

  # GET /event_types/1/edit
  def edit
  end

  # POST /event_types
  def create
    @event_type = EventType.new(event_type_params)

    if @event_type.save
      redirect_to @event_type, notice: "Event type was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /event_types/1
  def update
    if @event_type.update(event_type_params)
      redirect_to @event_type, notice: "Event type was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /event_types/1
  def destroy
    @event_type.destroy!
    redirect_to event_types_url, notice: "Event type was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_type
      @event_type = EventType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_type_params
      params.require(:event_type).permit(:name)
    end
end
