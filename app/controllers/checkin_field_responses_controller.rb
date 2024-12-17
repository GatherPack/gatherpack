class CheckinFieldResponsesController < InternalController
  before_action :set_checkin_field_response, only: %i[ show edit update destroy ]

  # GET /checkin_field_responses
  def index
    @q = policy_scope(CheckinFieldResponse).ransack(params[:q])
    @checkin_field_responses = @q.result(distinct: true).page(params[:page])
  end

  # GET /checkin_field_responses/1
  def show
  end

  # GET /checkin_field_responses/new
  def new
    @checkin_field_response = authorize CheckinFieldResponse.new
  end

  # GET /checkin_field_responses/1/edit
  def edit
  end

  # POST /checkin_field_responses
  def create
    @checkin_field_response = authorize CheckinFieldResponse.new(checkin_field_response_params)

    if @checkin_field_response.save
      redirect_to @checkin_field_response, notice: 'Checkin field response was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /checkin_field_responses/1
  def update
    if @checkin_field_response.update(checkin_field_response_params)
      redirect_to @checkin_field_response, notice: 'Checkin field response was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /checkin_field_responses/1
  def destroy
    @checkin_field_response.destroy!
    redirect_to checkin_field_responses_url, notice: 'Checkin field response was successfully destroyed.', status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_checkin_field_response
      @checkin_field_response = authorize policy_scope(CheckinFieldResponse).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def checkin_field_response_params
      params.require(:checkin_field_response).permit(:checkin_id, :checkin_field_id, :response)
    end
end
