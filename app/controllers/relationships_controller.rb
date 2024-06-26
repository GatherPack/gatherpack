class RelationshipsController < InternalController
  before_action :set_relationship, only: %i[ show edit update destroy ]

  # GET /relationships
  def index
    @q = policy_scope(Relationship).ransack(params[:q])
    @relationships = @q.result(distinct: true).page(params[:page])
  end

  # GET /relationships/1
  def show
  end

  # GET /relationships/new
  def new
    @relationship = authorize Relationship.new
  end

  # GET /relationships/1/edit
  def edit
  end

  # POST /relationships
  def create
    @relationship = authorize Relationship.new(relationship_params)

    if @relationship.save
      redirect_to @relationship, notice: "Relationship was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /relationships/1
  def update
    if @relationship.update(relationship_params)
      redirect_to @relationship, notice: "Relationship was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /relationships/1
  def destroy
    @relationship.destroy!
    redirect_to relationships_url, notice: "Relationship was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_relationship
      @relationship = authorize Relationship.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def relationship_params
      params.require(:relationship).permit(:relationship_type_id, :parent_id, :child_id)
    end
end
