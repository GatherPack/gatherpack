class MembershipApplicationsController < InternalController
  before_action :set_team_or_person
  before_action :set_membership_application, only: %i[show update destroy]

  # GET /teams/:team_id/membership_applications or /people/:person_id/membership_applications
  def index
    applications = if @team
      policy_scope(MembershipApplication).where(team: @team)
    elsif @person
      policy_scope(MembershipApplication).where(person: @person)
    end
    @membership_applications = applications.includes(:person, :team).order(created_at: :desc)
  end

  # GET /teams/:team_id/membership_applications/:id or /people/:person_id/membership_applications/:id
  def show
  end

  # POST /people/:person_id/membership_applications
  def create
    team = Team.find(params[:team_id])
    @membership_application = authorize team.membership_applications.build(
      person: current_user.person,
      message: params[:membership_application]&.[](:message)
    )

    if @membership_application.save
      redirect_to team_path(team), notice: "Application submitted."
    else
      redirect_to team_path(team), alert: @membership_application.errors.full_messages.to_sentence
    end
  end

  # PATCH /teams/:team_id/membership_applications/:id
  def update
    case params[:status]
    when "approved"
      @membership_application.approve!
      redirect_to team_memberships_path(@team), notice: "Application approved."
    when "denied"
      @membership_application.deny!
      redirect_to team_memberships_path(@team), notice: "Application denied."
    else
      redirect_to team_memberships_path(@team), alert: "Invalid status."
    end
  end

  # DELETE /people/:person_id/membership_applications/:id
  def destroy
    @membership_application.destroy!
    redirect_to person_membership_applications_path(@person), notice: "Application withdrawn.", status: :see_other
  end

  private

  def set_team_or_person
    @team = Team.find(params[:team_id]) if params[:team_id]
    @person = Person.find(params[:person_id]) if params[:person_id]
  end

  def set_membership_application
    scope = if @team
      @team.membership_applications
    elsif @person
      @person.membership_applications
    end
    @membership_application = authorize scope.find(params[:id])
  end
end
