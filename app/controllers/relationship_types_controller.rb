class RelationshipTypesController < InternalController
  before_action :set_relationship_type, only: %i[ show edit update destroy ]

  # GET /relationship_types
  def index
    @q = policy_scope(RelationshipType).ransack(params[:q])
    @q.sorts = "parent_label asc" if @q.sorts.empty?
    @relationship_types = @q.result(distinct: true).order(parent_label: :asc, child_label: :asc).page(params[:page])
  end

  # GET /relationship_types/1
  def show
  end

  # GET /relationship_types/new
  def new
    @relationship_type = authorize RelationshipType.new
  end

  # GET /relationship_types/1/edit
  def edit
  end

  # POST /relationship_types
  def create
    @relationship_type = authorize RelationshipType.new(relationship_type_params)

    if @relationship_type.save
      redirect_to @relationship_type, notice: 'Relationship type was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /relationship_types/1
  def update
    if @relationship_type.update(relationship_type_params)
      redirect_to @relationship_type, notice: 'Relationship type was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /relationship_types/1
  def destroy
    @relationship_type.destroy!
    redirect_to relationship_types_url, notice: 'Relationship type was successfully destroyed.', status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_relationship_type
      @relationship_type = authorize policy_scope(RelationshipType).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def relationship_type_params
      params.require(:relationship_type).permit(:parent_label, :child_label, :permission, parent_permissions: [], child_permissions: [])
    end
end
