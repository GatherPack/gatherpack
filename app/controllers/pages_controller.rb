class PagesController < ApplicationController
  before_action :set_page, only: %i[ show edit update destroy ]

  # GET /pages
  def index
    @q = policy_scope(Page).ransack(params[:q])
    @q.sorts = "title asc" if @q.sorts.empty?
    @pages = @q.result(distinct: true).order(title: :asc).page(params[:page])
  end

  # GET /pages/1
  def show
  end

  # GET /pages/new
  def new
    @page = authorize Page.new
  end

  # GET /pages/1/edit
  def edit
  end

  # POST /pages
  def create
    @page = authorize Page.new(page_params)

    if @page.save
      redirect_to @page, notice: 'Page was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pages/1
  def update
    if @page.update(page_params)
      redirect_to @page, notice: 'Page was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /pages/1
  def destroy
    @page.destroy!
    redirect_to pages_url, notice: 'Page was successfully destroyed.', status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = authorize policy_scope(Page).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def page_params
      params.require(:page).permit(:title, :content, :viewer, :editor, :dynamic, :team_id)
    end
end
