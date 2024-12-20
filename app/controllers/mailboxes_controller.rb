class MailboxesController < InternalController
  before_action :set_mailbox, only: %i[ show edit update destroy ]

  # GET /mailboxes
  def index
    @q = policy_scope(Mailbox).ransack(params[:q])
    @mailboxes = @q.result(distinct: true).page(params[:page])
  end

  # GET /mailboxes/1
  def show
    @q = policy_scope(@mailbox.messages).ransack(params[:q])
    @mailbox_messages = @q.result(distinct: true).page(params[:page])
  end

  # GET /mailboxes/new
  def new
    @mailbox = authorize Mailbox.new
  end

  # GET /mailboxes/1/edit
  def edit
  end

  # POST /mailboxes
  def create
    @mailbox = authorize Mailbox.new(mailbox_params)

    if @mailbox.save
      redirect_to @mailbox, notice: 'Mailbox was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /mailboxes/1
  def update
    if @mailbox.update(mailbox_params)
      redirect_to @mailbox, notice: 'Mailbox was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /mailboxes/1
  def destroy
    @mailbox.destroy!
    redirect_to mailboxes_url, notice: 'Mailbox was successfully destroyed.', status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mailbox
      @mailbox = authorize policy_scope(Mailbox).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def mailbox_params
      params.require(:mailbox).permit(:address)
    end
end
