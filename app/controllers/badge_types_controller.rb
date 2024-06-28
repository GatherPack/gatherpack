class BadgeTypesController < InternalController
  before_action :set_badge_type, only: %i[ show edit update destroy ]

  # GET /badge_types
  def index
    @q = policy_scope(BadgeType).ransack(params[:q])
    @badge_types = @q.result(distinct: true).page(params[:page])
  end

  # GET /badge_types/1
  def show
  end

  # GET /badge_types/new
  def new
    @badge_type = authorize BadgeType.new
  end

  # GET /badge_types/1/edit
  def edit
  end

  # POST /badge_types
  def create
    @badge_type = authorize BadgeType.new(badge_type_params)

    if @badge_type.save
      redirect_to @badge_type, notice: 'Badge type was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /badge_types/1
  def update
    if @badge_type.update(badge_type_params)
      redirect_to @badge_type, notice: 'Badge type was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /badge_types/1
  def destroy
    @badge_type.destroy!
    redirect_to badge_types_url, notice: 'Badge type was successfully destroyed.', status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_badge_type
      @badge_type = policy_scope(BadgeType).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def badge_type_params
      params.require(:badge_type).permit(:name)
    end
end
