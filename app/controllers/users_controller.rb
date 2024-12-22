class UsersController < InternalController
  before_action :set_person
  before_action :set_user, only: %i[ edit update ]

  def new
    @user = authorize User.new(person: @person)
  end

  def create
    @user = authorize User.new(user_params)
    @person.user = @user

    if @user.save
      redirect_to @person, notice: 'User information was successfully updated.', status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @person, notice: 'User information was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_person
      @person = authorize policy_scope(Person).find(params[:person_id])
    end

    def set_user
      @user = authorize policy_scope(User).find(params[:id])
    end

    def user_params
      params.require(:user).permit(:id, :email, :password, :password_confirmation, :admin, :person_id)
    end
end
