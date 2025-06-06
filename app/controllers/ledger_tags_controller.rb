class LedgerTagsController < InternalController
  before_action :set_ledger_tag, only: %i[ show edit update destroy ]
  before_action :check_for_admin

  # GET /ledger_tags
  def index
    @q = policy_scope(LedgerTag).ransack(params[:q])
    @ledger_tags = @q.result(distinct: true).page(params[:page])
  end

  # GET /ledger_tags/1
  def show
  end

  # GET /ledger_tags/new
  def new
    @ledger_tag = authorize LedgerTag.new
  end

  # GET /ledger_tags/1/edit
  def edit
  end

  # POST /ledger_tags
  def create
    @ledger_tag = authorize LedgerTag.new(ledger_tag_params)

    if @ledger_tag.save
      redirect_to @ledger_tag, notice: "Ledger tag was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ledger_tags/1
  def update
    if @ledger_tag.update(ledger_tag_params)
      redirect_to @ledger_tag, notice: "Ledger tag was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /ledger_tags/1
  def destroy
    @ledger_tag.destroy!
    redirect_to ledger_tags_url, notice: "Ledger tag was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ledger_tag
      @ledger_tag = authorize policy_scope(LedgerTag).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ledger_tag_params
      params.require(:ledger_tag).permit(:name, :color)
    end
end
