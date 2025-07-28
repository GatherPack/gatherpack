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
      redirect_to @person, notice: "User information was successfully updated.", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @person, notice: "User information was successfully updated.", status: :see_other
      if current_user == @user
        bypass_sign_in @user
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_person
      @person = authorize policy_scope(Person).find(params[:person_id])
    end

    def set_user
      @user = authorize @person.user
    end

    def user_params
      fields = [ :email, :password, :password_confirmation, :person_id, :old_password ]
      fields << :admin if current_user.admin?
      fields << :architect if current_user.architect?
      params.require(:user).permit(*fields)
    end
end
