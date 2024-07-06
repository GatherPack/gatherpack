class MembershipsController < InternalController
  before_action :set_team
  before_action :set_membership, only: %i[ update destroy ]

  # GET /memberships
  def index
    @q = policy_scope(Membership).ransack(params[:q])
    @memberships = @q.result(distinct: true).includes(:person).page(params[:page])
  end

  # POST /memberships
  # not currently used, but maybe it will be later?
  def create
    @membership = authorize Membership.new(membership_params)

    if @membership.save
      redirect_to team_memberships_path(@team), notice: 'Membership was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /memberships/1
  def update
    if @membership.update(membership_params)
      redirect_to team_memberships_path(@team), notice: 'Membership was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /memberships/1
  def destroy
    @membership.destroy!
    redirect_to team_memberships_path(@team), notice: 'Membership was successfully destroyed.', status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = policy_scope(Team).find(params[:team_id])
    end

    def set_membership
      @membership = @team.memberships.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def membership_params
      params.require(:membership).permit(:person_id, :manager)
    end
end
