require 'pp'

class SessionsController < ApplicationController
  
  layout 'single_column'
  
  def new
    # delete existing facebook cookie otherwise reauth may not work
    app_id = Cache.setting(Rails.configuration.domain_id, :system, 'Facebook App ID')
    cookies.delete "fbsr_#{app_id}"
  end
  
  def create
    user = User.find_by(domain_id: Rails.configuration.domain_id, email: params[:email], status: "active")

    if user && (user.password_digest.nil? || user.password_digest.length < 20)
      flash[:error] = "Invalid login. Did you log in using Facebook?"
      redirect_to login_path

    elsif user && user.authenticate(params[:password])
      session[:user_id] = user.id
      user.record_login(request, 'web')

      return  redirect_to params[:redirect] unless params[:redirect].blank?
      redirect_to account_root_path

    else
      flash[:error] = "Invalid email or password"
      redirect_to login_path
    end
  end

  def create_omniauth
    auth = request.env['omniauth.auth']

    # check if user exists
    user = User.find_by(domain_id: Rails.configuration.domain_id, email: auth.info.email)
    if user.nil?

      # WARNING:  extra.raw_info is Facebook specific
      user = User.new Rails.configuration.domain_id,
                      name: auth.info.name,
                      email: auth.info.email,
                      role_id: Role.find_by(default: true).id,
                      location: auth.info.location,
                      phone: auth.info.phone,
                      avatar_url: auth.info.image,
                      gender: auth.extra.raw_info.gender,
                      locale: auth.extra.raw_info.locale,
                      password_digest: SecureRandom.hex(5),
                      referral_key: SecureRandom.hex(5),
                      status: :active

      # try to guess timezone
      tz = ActiveSupport::TimeZone[auth.extra.raw_info.timezone]
      user.time_zone = tz.tzinfo.name unless tz.nil?

      unless user.save
        flash[:error] = "User account could not be created"
        return redirect_to :back
      end
    end

    saved_auth = Authorization.find_by(user_id: user.id, provider: auth.provider)
    saved_auth = Authorization.new user_id: user.id, provider: auth.provider if saved_auth.nil?

    # update values
    saved_auth.uid = auth.uid
    saved_auth.name = auth.info.name
    saved_auth.token = auth.credentials.token
    saved_auth.secret = auth.credentials.secret
    saved_auth.raw_info = auth.extra.raw_info
    saved_auth.save

    session[:user_id] = user.id
    user.record_login(request, auth.provider)

    return  redirect_to params[:redirect] unless params[:redirect].blank?
    redirect_to account_root_path
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "You have been logged out."
  end
  
end
