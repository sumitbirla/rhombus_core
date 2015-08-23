class Account::ProfileController < Account::BaseController

  def show
    @user = User.find(session[:user_id])
  end

  def edit
    @user = User.find(session[:user_id])
  end

  def update
    @user = User.find(session[:user_id])

    if @user && @user.authenticate(user_params[:current_password])
      @user.email = user_params[:email]
      @user.name = user_params[:name]

      unless user_params[:password].blank?

        if user_params[:password].length < 5
          @user.errors.add(:base, "New password must be atleast 5 characters long")
          return render 'edit'
        end

        if user_params[:password] != user_params[:password_confirmation]
          @user.errors.add(:base, "New passwords don't match.  Please re-enter the new password.")
          return render 'edit'
        end

        @user.password_digest = BCrypt::Password.create(user_params[:password])
      end

      return redirect_to action: 'show' if @user.save
    else
      @user.errors.add(:current_password,  "The current password entered is not correct.")
    end

    render 'edit'
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :phone, :replenishment_amount, :time_zone, :current_password, :password, :password_confirmation)
  end

end
