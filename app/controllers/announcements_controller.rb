class AnnouncementsController < InternalController
  before_action :set_announcement, only: %i[ show edit update destroy ]

  # GET /announcements
  def index
    @q = policy_scope(Announcement).ransack(params[:q])
    @announcements = @q.result(distinct: true).order(end_time: :asc, start_time: :asc).page(params[:page])
  end

  # GET /announcements/1
  def show
  end

  # GET /announcements/new
  def new
    @announcement = authorize Announcement.new(start_time: Time.now, end_time: Time.now + 1.week)
  end

  # GET /announcements/1/edit
  def edit
  end

  # POST /announcements
  def create
    @announcement = authorize Announcement.new(announcement_params)

    if @announcement.save
      redirect_to @announcement, notice: "Announcement was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /announcements/1
  def update
    if @announcement.update(announcement_params)
      redirect_to @announcement, notice: "Announcement was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /announcements/1
  def destroy
    @announcement.destroy!
    redirect_to announcements_url, notice: "Announcement was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_announcement
      @announcement = policy_scope(Announcement).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def announcement_params
      params.require(:announcement).permit(:title, :content, :start_time, :end_time, :team_id)
    end
end
