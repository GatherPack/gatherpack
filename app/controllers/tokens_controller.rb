class TokensController < InternalController
  before_action :set_token, only: %i[ show edit update destroy ]

  # GET /tokens
  def index
    @q = policy_scope(Token).ransack(params[:q])
    @q.sorts = "value asc" if @q.sorts.empty?
    @tokens = @q.result(distinct: true).order(value: :asc).page(params[:page])
  end

  # GET /tokens/1
  def show
  end

  # GET /tokens/new
  def new
    @token = authorize Token.new
  end

  # GET /tokens/1/edit
  def edit
  end

  # POST /tokens
  def create
    @token = authorize Token.new(token_params)

    if @token.save
      redirect_to @token, notice: "Token was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tokens/1
  def update
    if @token.update(token_params)
      redirect_to @token, notice: "Token was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /tokens/1
  def destroy
    @token.destroy!
    redirect_to tokens_url, notice: "Token was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_token
      @token = policy_scope(Token).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def token_params
      params.require(:token).permit(:value, :tokenable_nid)
    end
end
