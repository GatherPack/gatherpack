class BadgeAssignmentsController < InternalController
  before_action :set_badge
  before_action :set_badge_assignment, only: %i[ show edit update destroy ]

  # GET /badge_assignments
  def index
    authorize @badge, policy_class: BadgeAssignmentPolicy
    @q = policy_scope(@badge.badge_assignments).ransack(params[:q])
    @badge_assignments = @q.result(distinct: true).includes(:person).order("people.last_name ASC, people.first_name ASC").page(params[:page])
  end

  # GET /badges/1/badge_assignments/bulk
  def bulk
    authorize @badge, policy_class: BadgeAssignmentPolicy
    eligible = @badge.team ? @badge.team.all_people : policy_scope(Person)
    @q = eligible.ransack(params[:q])
    @people = @q.result(distinct: true).order(last_name: :asc, first_name: :asc).page(params[:page])
    @assigned_ids = @badge.badge_assignments.where(person_id: @people.map(&:id)).pluck(:person_id).to_set
  end

  # PATCH /badges/1/badge_assignments/bulk
  def bulk_update
    person = Person.find(params[:person_id])
    earned_at = (Date.iso8601(params[:earned_on].to_s) rescue Date.current).in_time_zone

    if ActiveModel::Type::Boolean.new.cast(params[:assigned])
      assignment = authorize @badge.badge_assignments.find_or_initialize_by(person: person), :create?
      assignment.earned_at = earned_at
      if assignment.save
        render json: { assigned: true }
      else
        render json: { errors: assignment.errors.full_messages }, status: :unprocessable_entity
      end
    else
      assignment = @badge.badge_assignments.find_by(person: person)
      if assignment
        authorize assignment, :destroy?
        assignment.destroy!
      else
        skip_authorization
      end
      render json: { assigned: false }
    end
  end

  # GET /badge_assignments/1
  def show
  end

  # GET /badge_assignments/new
  def new
    @badge_assignment = authorize @badge.badge_assignments.build
  end

  # GET /badge_assignments/1/edit
  def edit
    redirect_to [ @badge, @badge_assignment ]
  end

  # POST /badge_assignments
  def create
    @badge_assignment = authorize @badge.badge_assignments.build(badge_assignment_params)

    if @badge_assignment.save
      redirect_to [ @badge, @badge_assignment ], notice: "Badge assignment was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /badge_assignments/1
  def update
    if @badge_assignment.update(badge_assignment_params)
      redirect_to [ @badge, @badge_assignment ], notice: "Badge assignment was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /badge_assignments/1
  def destroy
    @badge_assignment.destroy!
    redirect_to badge_badge_assignments_url(@badge), notice: "Badge assignment was successfully destroyed.", status: :see_other
  end

  private

    def set_badge
      @badge = policy_scope(Badge).find(params[:badge_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_badge_assignment
      @badge_assignment = authorize policy_scope(BadgeAssignment).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def badge_assignment_params
      params.require(:badge_assignment).permit(:badge_id, :person_id, :earned_at)
    end
end
