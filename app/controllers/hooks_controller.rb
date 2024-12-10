class HooksController < InternalController
  before_action :set_hook, only: %i[ show edit update destroy ]
  before_action :check_for_admin

  # GET /hooks
  def index
    @q = Hook.ransack(params[:q])
    @hooks = @q.result(distinct: true).order(event: :asc, name: :asc).page(params[:page])
  end

  # GET /hooks/1
  def show
  end

  # GET /hooks/new
  def new
    @hook = authorize Hook.new
  end

  # GET /hooks/1/edit
  def edit
  end

  # POST /hooks
  def create
    @hook = authorize Hook.new(hook_params)

    if @hook.save
      redirect_to @hook, notice: 'Hook was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /hooks/1
  def update
    if @hook.update(hook_params)
      redirect_to @hook, notice: 'Hook was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /hooks/1
  def destroy
    @hook.destroy!
    redirect_to hooks_url, notice: 'Hook was successfully destroyed.', status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hook
      @hook = authorize Hook.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def hook_params
      params.require(:hook).permit(:name, :event, :code)
    end
end
