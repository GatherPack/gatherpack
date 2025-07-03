class NotifiersController < InternalController
  before_action :set_notifier, only: %i[ show edit update destroy ]

  # GET /notifiers
  def index
    @q = policy_scope(Notifier).ransack(params[:q])
    @notifiers = @q.result(distinct: true).page(params[:page])
  end

  # GET /notifiers/1
  def show
  end

  # GET /notifiers/new
  def new
    @notifier = authorize Notifier.new
  end

  # GET /notifiers/1/edit
  def edit
  end

  # POST /notifiers
  def create
    @notifier = authorize Notifier.new(notifier_params)

    if @notifier.save
      redirect_to @notifier, notice: 'Notifier was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notifiers/1
  def update
    if @notifier.update(notifier_params)
      redirect_to @notifier, notice: 'Notifier was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /notifiers/1
  def destroy
    @notifier.destroy!
    redirect_to notifiers_url, notice: 'Notifier was successfully destroyed.', status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notifier
      @notifier = authorize policy_scope(Notifier).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def notifier_params
      params.require(:notifier).permit(:person_id, :scope, :schedule, :target)
    end
end
