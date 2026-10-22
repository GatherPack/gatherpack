class PeopleController < InternalController
  before_action :set_person, only: %i[ show edit update destroy impersonate recent_activity calendar statistics relationships teams ]

  # GET /people
  def index
    @q = policy_scope(Person).ransack(params[:q])
    @q.sorts = "last_name asc" if @q.sorts.empty?
    @people = @q.result(distinct: true).order(last_name: :asc, first_name: :asc).page(params[:page])
  end

  # GET /people/1
  def show
    @teams = policy_scope(@person.all_ancestor_teams).includes(:team_type).order('team_type.name': :asc, name: :asc)
    @badges = policy_scope(@person.badges).order(name: :asc)
    @tokens = policy_scope(@person.tokens).order(value: :asc)
    @ledgers = policy_scope(@person.ledgers).order(name: :asc)
    @relationships = policy_scope(@person.relationships).includes(:relationship_type).order('relationship_type.parent_label': :asc, 'relationship_type.child_label': :asc, created_at: :asc)
    @time_clocks = policy_scope(@person.time_clock_punches).order(time_clock_period_id: :asc).map do |punch|
      Hash[TimeClockPeriod.find_by_id(punch.time_clock_period_id), punch.hours]
    end.reduce do |a, b|
      a.merge(b) { |_, c, d| c + d }
    end
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
      redirect_to @person, notice: "Person was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /people/1
  def update
    if @person.update(person_params)
      redirect_to @person, notice: "Person was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /people/1
  def destroy
    @person.destroy!
    redirect_to people_url, notice: "Person was successfully destroyed.", status: :see_other
  end

  def impersonate
    user = @person.user
    impersonate_user(user)
    redirect_back_or_to root_path
  end

  # Always allowed: it only returns an impersonating admin to themselves.
  def stop_impersonating
    skip_authorization
    stop_impersonating_user
    redirect_back_or_to root_path
  end

  def recent_activity
    @upcoming_events = policy_scope(@person.events).where("start_time > ?", Time.current)
    @recent_punches = policy_scope(@person.time_clock_punches).order(start_time: :desc).first(10)
    @recent_notes = policy_scope(@person.calendar_notes).order(start_time: :desc).first(3)
  end

  def calendar
  end

  def statistics
  end

  def relationships
  end

  def teams
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = authorize policy_scope(Person).find(params[:id])
    end

    # Only allow a list of trusted parameters through. Linking to a User is
    # admin-only. Managers may also assign teams and badges, but only ones they
    # control; memberships and badges outside that are left untouched.
    def person_params
      fields = [ :first_name, :last_name, :display_name, :gender, :shirt_size, :phone_number, :address, :birthday, :dietary_restrictions, :avatar, :bio, :email ]
      if current_user.admin?
        fields += [ :user_id, team_ids: [], badge_ids: [] ]
      elsif @person && current_user.person&.can_manage(@person)
        fields += [ team_ids: [], badge_ids: [] ]
      end
      permitted = params.require(:person).permit(*fields)
      current_user.admin? ? permitted : limit_to_manageable(permitted)
    end

    def limit_to_manageable(permitted)
      if permitted.key?(:team_ids)
        manageable = current_user.person.all_managed_teams.pluck(:id)
        permitted[:team_ids] = merge_manageable_ids(@person.team_ids, permitted[:team_ids], manageable)
      end
      if permitted.key?(:badge_ids)
        manageable = policy_scope(Badge).select { |badge| BadgePolicy.new(current_user, badge).update? }.map(&:id)
        permitted[:badge_ids] = merge_manageable_ids(@person.badge_ids, permitted[:badge_ids], manageable)
      end
      permitted
    end

    # Apply the requested ids only within the manageable set, and keep whatever
    # the person already has outside it.
    def merge_manageable_ids(current, requested, manageable)
      (requested.compact_blank & manageable) | (current - manageable)
    end
end
