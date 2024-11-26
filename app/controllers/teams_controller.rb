class TeamsController < InternalController
  before_action :set_team, only: %i[ show edit update destroy ]

  # GET /teams
  def index
    @q = policy_scope(Team).ransack(params[:q])
    @teams = @q.result(distinct: true).includes(:team_type).order('team_type.name': :asc, name: :asc).page(params[:page]).includes(:team_type, :people)
  end

  # GET /teams/1
  def show
  end

  # GET /teams/new
  def new
    @team = authorize Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  def create
    @team = authorize Team.new(team_params)

    if @team.save
      redirect_to @team, notice: 'Team was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /teams/1
  def update
    if authorize(@team).update(permitted_attributes(@team))
      redirect_to @team, notice: 'Team was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /teams/1
  def destroy
    @team.destroy!
    redirect_to teams_url, notice: 'Team was successfully destroyed.', status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = policy_scope(Team).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def team_params
      params.require(:team).permit(:name, :color, :team_type_id, :join_permission, person_ids: [])
    end
end
