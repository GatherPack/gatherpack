class LedgerEntriesController < InternalController
  before_action :set_ledger
  before_action :set_ledger_entry, only: %i[ show edit update destroy split unsplit ]

  # GET /ledger_entries/1
  def show
  end

  # GET /ledger_entries/new
  def new
    @ledger_entry = authorize @ledger.ledger_entries.build(created_at: Time.now)
  end

  # GET /ledger_entries/1/edit
  def edit
  end

  # POST /ledger_entries
  def create
    @ledger_entry = authorize @ledger.ledger_entries.build(ledger_entry_params)
    @ledger_entry.created_by = current_user

    if @ledger_entry.save
      redirect_to ledger_ledger_entry_path(@ledger, @ledger_entry), notice: "Ledger entry was successfully created."
    else
      puts JSON.pretty_generate(@ledger_entry.errors.to_a)
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ledger_entries/1
  def update
    if @ledger_entry.update(ledger_entry_params)
      @ledger_entry.linked_entries.each do |e|
        e.update(ledger_entry_params.except(:remark))
      end
      redirect_to ledger_ledger_entry_path(@ledger, @ledger_entry), notice: "Ledger entry was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /ledger_entries/1
  def destroy
    @ledger_entry.destroy!
    redirect_to @ledger, notice: "Ledger entry was successfully destroyed.", status: :see_other
  end

  def split
    2.times do
      e = @ledger_entry.child_entries.build(ledger: @ledger, created_by: @ledger_entry, amount_cents: 0, remark: "Split from #{@ledger_entry.remark}")
      e.save
    end
    redirect_to edit_ledger_ledger_entry_path(@ledger_entry)
  end

  def unsplit
    @ledger_entry.child_entries.each(&:destroy)
    redirect_to edit_ledger_ledger_entry_path(@ledger_entry)
  end

  private
    def set_ledger
      @ledger = authorize policy_scope(Ledger).find(params[:ledger_id])
    end

    def set_ledger_entry
      @ledger_entry = authorize policy_scope(@ledger.ledger_entries).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ledger_entry_params
      params.require(:ledger_entry).permit(:remark, :amount, :approved, receipts: [], ledger_tag_ids: [], child_entries_attributes: [ :id, :remark, :amount, ledger_tag_ids: [] ])
    end
end
