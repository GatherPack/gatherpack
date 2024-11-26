class AccountsController < InternalController
  before_action :set_account, only: %i[ show edit update destroy ]

  # GET /accounts
  def index
    @q = policy_scope(Account).ransack(params[:q])
    @accounts = @q.result(distinct: true).order(name: :asc).page(params[:page])
  end

  # GET /accounts/1
  def show
    @transaction = Transaction.new(account: @account)
  end

  # GET /accounts/new
  def new
    @account = authorize Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  def create
    @account = authorize Account.new(account_params)

    if @account.save
      redirect_to @account, notice: 'Account was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /accounts/1
  def update
    if @account.update(account_params)
      redirect_to @account, notice: 'Account was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /accounts/1
  def destroy
    @account.destroy!
    redirect_to accounts_url, notice: 'Account was successfully destroyed.', status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = authorize policy_scope(Account).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def account_params
      params.require(:account).permit(:name, :team_id)
    end
end
