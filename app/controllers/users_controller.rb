class UsersController < ApplicationController
  
  layout 'single_column'
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)

    if @user.password.length < 5
      @user.errors[:base] <<  "must be at least 5 characters long"
      return render 'new'
    end

    unless @user.password_confirmed?
      @user.errors[:base] <<  "Passwords do not match"
      return render 'new'
    end

    @user.domain_id = Rails.configuration.domain_id
    @user.role_id = Role.find_by(default: true).id
    @user.password_digest = BCrypt::Password.create(@user.password)
    @user.referral_key = SecureRandom.hex(5)

    if @user.save
      session[:user_id] = @user.id
      @user.record_login(request, 'web')

      begin
        UserMailer.welcome_email(@user).deliver
      rescue Exception => e
        logger.error e
      end

      return redirect_to params[:redirect]  unless params[:redirect].blank?
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
      flash[:notice] = 'This email does not exist in our system.'
      return redirect_to :back
    end

    # create a temporary token
    token = TemporaryToken.create user_id: user.id, value: SecureRandom.hex(5), expires: Time.now + 1.day
    reset_url = Cache.setting('System', 'Website URL') + '/resetp/' + token.value

    begin
      UserMailer.reset_password_email(user, reset_url).deliver
      flash[:notice] = "Password reset instructions have been emailed to #{user.email}"
    rescue Exception => e
      flash[:error] = e.message
      return redirect_to :back
    end

    render 'shared/notice'
  end


  def new_password

    @token = TemporaryToken.find_by(value: params[:id])

    unless @token
      flash[:notice] = "This link appears to be invalid.  Please re-request password reset or contact customer support."
      return render 'shared/notice'
    end

    @user = @token.user

  end


  def update_password
    @token = TemporaryToken.find_by(value: params[:token])
    @user = User.new(user_params)

    unless @user.password_confirmed?
      @user.errors[:base] <<  "Passwords do not match"
      return render 'new_password'
    end

    if @user.password.length < 5
      @user.errors[:base] <<  "Password must be atleast 5 characters long"
      return render 'new_password'
    end

    @token.user.update_attribute(:password_digest, BCrypt::Password.create(@user.password))
    @token.destroy

    flash[:notice] = 'You password has been reset. You may now log in with your new password.'
    redirect_to login_path
  end


  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  
end
