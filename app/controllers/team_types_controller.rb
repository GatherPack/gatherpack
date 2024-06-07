class TeamTypesController < InternalController
  before_action :set_team_type, only: %i[ show edit update destroy ]
  before_action :check_for_admin

  # GET /team_types
  def index
    @q = TeamType.ransack(params[:q])
    @team_types = authorize @q.result(distinct: true).page(params[:page]).includes(:teams)
  end

  # GET /team_types/1
  def show
  end

  # GET /team_types/new
  def new
    @team_type = authorize TeamType.new
  end

  # GET /team_types/1/edit
  def edit
  end

  # POST /team_types
  def create
    @team_type = TeamType.new(team_type_params)

    if @team_type.save
      redirect_to @team_type, notice: 'Team type was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /team_types/1
  def update
    if @team_type.update(team_type_params)
      redirect_to @team_type, notice: 'Team type was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /team_types/1
  def destroy
    @team_type.destroy!
    redirect_to team_types_url, notice: 'Team type was successfully destroyed.', status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team_type
      @team_type = authorize TeamType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def team_type_params
      params.require(:team_type).permit(:name, :icon)
    end
end
