class CalendarNotesController < InternalController
  before_action :set_calendar_note, only: %i[ show edit update destroy ]

  # GET /calendar_notes
  def index
    @q = policy_scope(CalendarNote).ransack(params[:q])
    @q.sorts = "name asc" if @q.sorts.empty?
    @calendar_notes = @q.result(distinct: true).page(params[:page])
  end

  # GET /calendar_notes/1
  def show
  end

  # GET /calendar_notes/new
  def new
    @calendar_note = authorize CalendarNote.new
  end

  # GET /calendar_notes/1/edit
  def edit
  end

  # POST /calendar_notes
  def create
    @calendar_note = authorize CalendarNote.new(calendar_note_params)

    if @calendar_note.save
      redirect_to @calendar_note, notice: 'Calendar note was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /calendar_notes/1
  def update
    if @calendar_note.update(calendar_note_params)
      redirect_to @calendar_note, notice: 'Calendar note was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /calendar_notes/1
  def destroy
    @calendar_note.destroy!
    redirect_to calendar_notes_url, notice: 'Calendar note was successfully destroyed.', status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calendar_note
      @calendar_note = authorize policy_scope(CalendarNote).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def calendar_note_params
      params.require(:calendar_note).permit(:name, :description, :start_time, :end_time, :noteable_nid)
    end
end
