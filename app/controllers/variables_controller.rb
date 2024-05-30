class VariablesController < ApplicationController
  before_action :set_variable, only: %i[ show edit update destroy ]

  # GET /variables
  def index
    @q = Variable.ransack(params[:q])
    @variables = @q.result(distinct: true).page(params[:page])
  end

  # GET /variables/1
  def show
  end

  # GET /variables/new
  def new
    @variable = Variable.new
  end

  # GET /variables/1/edit
  def edit
  end

  # POST /variables
  def create
    @variable = Variable.new(variable_params)

    if @variable.save
      redirect_to @variable, notice: "Variable was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /variables/1
  def update
    if @variable.update(variable_params)
      redirect_to @variable, notice: "Variable was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /variables/1
  def destroy
    @variable.destroy!
    redirect_to variables_url, notice: "Variable was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_variable
      @variable = Variable.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def variable_params
      params.require(:variable).permit(:name, :klass, :raw_value)
    end
end
