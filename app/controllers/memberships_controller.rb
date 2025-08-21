class MembershipsController < InternalController
  before_action :set_team_or_person
  before_action :set_membership, only: %i[ show edit update destroy ]

  # GET /memberships
  def index
    @q = false
    if @team
      @q = policy_scope(Membership).where(team: @team).ransack(params[:q])
    elsif @person
      @q = policy_scope(Membership).where(person: @person).ransack(params[:q])
    end
    @memberships = @q.result(distinct: true).includes(:person).includes(:team).order("person.last_name" => "desc", "team.name" => "asc").page(params[:page])
    if @team
      render "by_team"
    elsif @person
      render "by_person"
    end
  end

  def show
  end

  def new
    @membership = authorize (@team || @person).memberships.build
  end

  # POST /memberships
  def create
    @membership = authorize (@team || @person).memberships.build(membership_params)

    if @membership.save
      target = if @team
        team_memberships_path(@team)
      else
        person_memberships_path(@person)
      end
      redirect_to target, notice: "Membership was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  # PATCH/PUT /memberships/1
  def update
    target = if @team
      team_memberships_path(@team)
    else
      person_memberships_path(@person)
    end
    if @membership.update(membership_params)
      redirect_to target, notice: "Membership was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /memberships/1
  def destroy
    target = if @team
        team_memberships_path(@team)
      else
        person_memberships_path(@person)
      end
    @membership.destroy!
    redirect_to target, notice: "Membership was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team_or_person
      @team = policy_scope(Team).find(params[:team_id]) if params[:team_id]
      @person = policy_scope(Person).find(params[:person_id]) if params[:person_id]
    end

    def set_membership
      @membership = authorize (@team || @person).memberships.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def membership_params
      params.require(:membership).permit(:person_id, :team_id, :manager)
    end
end
