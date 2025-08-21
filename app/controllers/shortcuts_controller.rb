class ShortcutsController < InternalController
  before_action :set_shortcut, only: %i[ show edit update destroy ]

  # GET /shortcuts
  def index
    @q = policy_scope(Shortcut).ransack(params[:q])
    @shortcuts = @q.result(distinct: true).page(params[:page])
  end

  # GET /shortcuts/1
  def show
  end

  # GET /shortcuts/new
  def new
    @shortcut = authorize Shortcut.new
  end

  # GET /shortcuts/1/edit
  def edit
  end

  # POST /shortcuts
  def create
    @shortcut = authorize Shortcut.new(shortcut_params)

    if @shortcut.save
      redirect_to @shortcut, notice: 'Shortcut was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /shortcuts/1
  def update
    if @shortcut.update(shortcut_params)
      redirect_to @shortcut, notice: 'Shortcut was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /shortcuts/1
  def destroy
    @shortcut.destroy!
    redirect_to shortcuts_url, notice: 'Shortcut was successfully destroyed.', status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shortcut
      @shortcut = authorize policy_scope(Shortcut).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shortcut_params
      params.require(:shortcut).permit(:name, :target, :icon, :color, :team_id)
    end
end
