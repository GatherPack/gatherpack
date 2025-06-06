class GatewaysController < InternalController
  before_action :set_gateway, only: %i[ show edit update destroy ]

  # GET /gateways
  def index
    @q = policy_scope(Gateway).ransack(params[:q])
    @gateways = @q.result(distinct: true).page(params[:page])
  end

  # GET /gateways/1
  def show
  end

  # GET /gateways/new
  def new
    @gateway = authorize Gateway.new(type: params[:type])
  end

  # GET /gateways/1/edit
  def edit
  end

  # POST /gateways
  def create
    @gateway = authorize Gateway.new(type: params[:type])
    @gateway.attributes = gateway_params

    if @gateway.save
      redirect_to gateway_path(@gateway), notice: 'Gateway was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /gateways/1
  def update
    if @gateway.update(gateway_params)
      redirect_to gateway_path(@gateway), notice: 'Gateway was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /gateways/1
  def destroy
    @gateway.destroy!
    redirect_to gateways_url, notice: 'Gateway was successfully destroyed.', status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gateway
      @gateway = authorize policy_scope(Gateway).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def gateway_params
      fields = @gateway.fields + [:name]
      params.require(:gateway).permit(fields)
    end
end
