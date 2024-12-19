class CheckinFieldsController < InternalController
  before_action :set_checkin_field, only: %i[ show edit update destroy ]

  # GET /checkin_fields
  def index
    @q = policy_scope(CheckinField).ransack(params[:q])
    @checkin_fields = @q.result(distinct: true).page(params[:page])
  end

  # GET /checkin_fields/1
  def show
  end

  # GET /checkin_fields/new
  def new
    @checkin_field = authorize CheckinField.new
  end

  # GET /checkin_fields/1/edit
  def edit
  end

  # POST /checkin_fields
  def create
    @checkin_field = authorize CheckinField.new(checkin_field_params)

    if @checkin_field.save
      redirect_to @checkin_field, notice: 'Checkin field was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /checkin_fields/1
  def update
    if @checkin_field.update(checkin_field_params)
      redirect_to @checkin_field, notice: 'Checkin field was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /checkin_fields/1
  def destroy
    @checkin_field.destroy!
    redirect_to checkin_fields_url, notice: 'Checkin field was successfully destroyed.', status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_checkin_field
      @checkin_field = authorize policy_scope(CheckinField).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def checkin_field_params
      params.require(:checkin_field).permit(:event_type_id, :name, :permission)
    end
end
