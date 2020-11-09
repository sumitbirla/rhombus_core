class UsersController < ApplicationController

  layout 'single_column'

  def new
    @user = User.new
  end

  # Create a new user. Note that a user with this email may already exist in status "Z"
  def create
    @user = User.find_by(domain_id: Rails.configuration.domain_id, email: user_params[:email], status: "Z") || User.new
    @user.assign_attributes(user_params)

    if @user.password.length < 5
      @user.errors[:password] << "must be at least 5 characters long"
      return render 'new'
    end

    unless @user.password_confirmed?
      @user.errors[:base] << "Passwords do not match"
      return render 'new'
    end

    @user.assign_attributes(
        domain_id: Rails.configuration.domain_id,
        role_id: Role.find_by(default: true).id,
        password_digest: BCrypt::Password.create(@user.password),
        referral_key: SecureRandom.hex(5),
        status: :active)

    if @user.save
      session[:user_id] = @user.id
      @user.record_login(request, 'web')

      # subscribe user to email list
      if params[:email_signup] == "1"

      end

      begin
        UserMailer.welcome_email(@user.id).deliver_later
      rescue Exception => e
        logger.error e
      end

      return redirect_to params[:redirect] unless params[:redirect].blank?
      redirect_to root_path
    else
      render 'new'
    end

  end


  def reset_password

  end

  def reset_password_email

    user = User.find_by(email: params[:email], domain_id: Rails.configuration.domain_id)
    unless user
      flash[:error] = 'This email does not exist in our system.'
      return redirect_back(fallback_location: reset_password_path)
    end

    # create a temporary token
    token = TemporaryToken.create user_id: user.id, value: SecureRandom.hex(5), expires: Time.now + 1.day
    reset_url = Cache.setting(Rails.configuration.domain_id, :system, 'Website URL') + '/resetp/' + token.value

    begin
      UserMailer.reset_password_email(user, reset_url).deliver_later
      flash.now[:notice] = "Password reset instructions have been emailed to #{user.email}"
    rescue Exception => e
      flash[:error] = e.message
      return redirect_back(fallback_location: reset_password_path)
    end

    render 'shared/notice'
  end


  def new_password
    @token = TemporaryToken.find_by(value: params[:id])

    unless @token
      flash.now[:notice] = "This link appears to be invalid.  Please re-request password reset or contact customer support."
      return render 'shared/notice'
    end

    @user = @token.user
  end


  def update_password
    @token = TemporaryToken.find_by(value: params[:token])
    @user = User.new(user_params)

    unless @user.password_confirmed?
      @user.errors[:base] << "Passwords do not match"
      return render 'new_password'
    end

    if @user.password.length < 5
      @user.errors[:base] << "Password must be atleast 5 characters long"
      return render 'new_password'
    end

    @token.user.update(password_digest: BCrypt::Password.create(@user.password), status: :active)
    @token.destroy

    flash[:info] = 'Your password has been reset. You may now log in with your new password.'
    redirect_to login_path
  end


  def status
    user = User.find(params[:id])
    render json: {status: user.nil? ? "not found" : user.status}
  end


  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :data1, :data2)
  end

end
