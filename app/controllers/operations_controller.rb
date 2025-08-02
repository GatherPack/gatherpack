class OperationsController < InternalController
  before_action :set_operation, only: %i[ show run edit update destroy ]

  # GET /operations
  def index
    @q = policy_scope(Operation).ransack(params[:q])
    @operations = @q.result(distinct: true).page(params[:page])
  end

  # GET /operations/1
  def show
  end

  def run
    authorize @operation
    eval(@operation.code)
    render html: ERB.new(@operation.view).result(binding)
  end

  # GET /operations/new
  def new
    @operation = authorize Operation.new
  end

  # GET /operations/1/edit
  def edit
  end

  # POST /operations
  def create
    @operation = authorize Operation.new(operation_params)

    if @operation.save
      redirect_to @operation, notice: "Operation was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /operations/1
  def update
    if @operation.update(operation_params)
      redirect_to @operation, notice: "Operation was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /operations/1
  def destroy
    @operation.destroy!
    redirect_to operations_url, notice: "Operation was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_operation
      @operation = authorize policy_scope(Operation).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def operation_params
      params.require(:operation).permit(:name, :permission, :model, :scope, :icon, :color, :code, :view)
    end
end
