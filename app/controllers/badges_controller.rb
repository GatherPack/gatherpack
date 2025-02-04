class BadgesController < InternalController
  before_action :set_badge, only: %i[ show edit update destroy ]

  # GET /badges
  def index
    @q = policy_scope(Badge).ransack(params[:q])
    @q.sorts = "name asc" if @q.sorts.empty?
    @badges = @q.result(distinct: true).order(name: :asc).includes(:people).page(params[:page])
  end

  # GET /badges/1
  def show
  end

  # GET /badges/new
  def new
    @badge = authorize Badge.new
  end

  # GET /badges/1/edit
  def edit
  end

  # POST /badges
  def create
    @badge = authorize Badge.new(badge_params)

    if @badge.save
      redirect_to @badge, notice: 'Badge was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /badges/1
  def update
    if @badge.update(badge_params)
      redirect_to @badge, notice: 'Badge was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /badges/1
  def destroy
    @badge.destroy!
    redirect_to badges_url, notice: 'Badge was successfully destroyed.', status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_badge
      @badge = authorize policy_scope(Badge).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def badge_params
      if policy(Badge).new? || policy(@badge).update?
        params.require(:badge).permit(:name, :description, :color, :short, :badge_type_id, :team_id, :permission, person_ids: [])
      else
        params.require(:badge).permit(person_ids: [])
      end
    end
end
