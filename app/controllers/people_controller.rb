class PeopleController < InternalController
  before_action :set_person, only: %i[ show edit update destroy ]

  # GET /people
  def index
    @q = policy_scope(Person).ransack(params[:q])
    @people = @q.result(distinct: true).order(last_name: :asc, first_name: :asc).page(params[:page])
  end

  # GET /people/1
  def show
    @teams = policy_scope(@person.teams).includes(:team_type).order('team_type.name': :asc, name: :asc)
    @badges = policy_scope(@person.badges).order(name: :asc)
    @tokens = policy_scope(@person.tokens).order(value: :asc)
    @accounts = policy_scope(@person.accounts).order(name: :asc)
    @relationships = policy_scope(@person.relationships).includes(:relationship_type).order('relationship_type.parent_label': :asc, 'relationship_type.child_label': :asc, created_at: :asc)
    @time_clock_punches = @person.time_clock_punches.where(person: @person).order(start_time: :desc, end_time: :desc)
    @time_clock_periods = TimeClockPeriod.where(time_clock_punches: @time_clock_punches)
  end

  # GET /people/new
  def new
    @person = authorize Person.new
    @person.user = User.new
  end

  # GET /people/1/edit
  def edit
    if @person.user.nil?
      @person.user = User.new
    end
  end

  # POST /people
  def create
    @person = authorize Person.new(person_params)

    if @person.save
      if @person.email
        pw = Spicy::Proton.pair
        User.create(email: @person.email, person: @person, password: pw)
        flash[:info] = "User was successfully created, password set to #{pw}"
      end
      redirect_to @person, notice: 'Person was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /people/1
  def update
    if @person.update(person_params)
      redirect_to @person, notice: 'Person was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /people/1
  def destroy
    @person.destroy!
    redirect_to people_url, notice: 'Person was successfully destroyed.', status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = policy_scope(Person).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def person_params
      params.require(:person).permit(:first_name, :last_name, :display_name, :gender, :shirt_size, :phone_number, :address, :birthday, :dietary_restrictions, :user_id, :avatar, :email, user_attributes: [ :id, :email, :password, :password_confirmation ], team_ids: [], badge_ids: [])
    end
end
