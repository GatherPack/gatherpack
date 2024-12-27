class MailboxMessagesController < InternalController
  before_action :set_mailbox
  before_action :set_mailbox_message, only: %i[ show edit update destroy ]

  # GET /mailbox_messages
  def index
    @q = policy_scope(MailboxMessage).ransack(params[:q])
    @mailbox_messages = @q.result(distinct: true).page(params[:page])
  end

  # GET /mailbox_messages/1
  def show
  end

  # GET /mailbox_messages/new
  def new
    @mailbox_message = authorize MailboxMessage.new
  end

  # GET /mailbox_messages/1/edit
  def edit
  end

  # POST /mailbox_messages
  def create
    @mailbox_message = authorize MailboxMessage.new(mailbox_message_params)

    if @mailbox_message.save
      redirect_to @mailbox_message, notice: 'Mailbox message was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /mailbox_messages/1
  def update
    if @mailbox_message.update(mailbox_message_params)
      redirect_to @mailbox_message, notice: 'Mailbox message was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /mailbox_messages/1
  def destroy
    @mailbox_message.destroy!
    redirect_to @mailbox, notice: 'Mailbox message was successfully destroyed.', status: :see_other
  end

  private
    def set_mailbox
      @mailbox = authorize policy_scope(Mailbox).find(params[:mailbox_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_mailbox_message
      @mailbox_message = authorize policy_scope(@mailbox.messages).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def mailbox_message_params
      params.require(:mailbox_message).permit(:from, :subject, :body_raw, :mailbox_id)
    end
end
