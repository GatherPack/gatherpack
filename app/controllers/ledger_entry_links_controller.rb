class LedgerEntryLinksController < InternalController
  before_action :set_ledger_entry_link, only: %i[ show edit update destroy ]

  # GET /ledger_entry_links
  def index
    @q = policy_scope(LedgerEntryLink).ransack(params[:q])
    @ledger_entry_links = @q.result(distinct: true).page(params[:page])
  end

  # GET /ledger_entry_links/1
  def show
  end

  # GET /ledger_entry_links/new
  def new
    @ledger_entry_link = authorize LedgerEntryLink.new
  end

  # GET /ledger_entry_links/1/edit
  def edit
  end

  # POST /ledger_entry_links
  def create
    @ledger_entry_link = authorize LedgerEntryLink.new(ledger_entry_link_params)

    if @ledger_entry_link.save
      redirect_to @ledger_entry_link, notice: 'Ledger entry link was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ledger_entry_links/1
  def update
    if @ledger_entry_link.update(ledger_entry_link_params)
      redirect_to @ledger_entry_link, notice: 'Ledger entry link was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /ledger_entry_links/1
  def destroy
    @ledger_entry_link.destroy!
    redirect_to ledger_entry_links_url, notice: 'Ledger entry link was successfully destroyed.', status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ledger_entry_link
      @ledger_entry_link = authorize policy_scope(LedgerEntryLink).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ledger_entry_link_params
      params.fetch(:ledger_entry_link, {})
    end
end
