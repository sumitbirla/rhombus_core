require 'cbor'
require 'base64'
require 'digest'
require 'openssl'
require 'cose'

class Admin::SessionsController < Admin::BaseController
  skip_before_action :require_login, raise: false
  skip_before_action :verify_authenticity_token, only: :passkey_login

  layout 'admin/layouts/dialog'

  def new
    @challenge = SecureRandom.base64(32)
    session[:authentication_challenge] = @challenge  # Passkey challenge for verification in create action
  end

  def create
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      cookies.permanent.signed[:user_id] = user.id if params[:remember_me] == "1"

      user.record_login(request, 'admin')
      cookies[:domain_id] = {:value => Domain.first.id, :expires => 1.year.from_now} if cookies[:domain_id].nil?

      unless params[:redirect].blank?
        redirect_to params[:redirect]
        return
      end

      redirect_to user.role.landing_page || admin_root_path
    else
      flash[:error] = "Invalid email or password"
      redirect_to admin_login_path
    end
  end

  def passkey_login
    begin
      client_data_json = Base64.decode64(params[:clientDataJSON])
      authenticator_data = Base64.decode64(params[:authenticatorData])
      signature = Base64.decode64(params[:signature])
      credential_id = Base64.decode64(params[:id])
      client_data = JSON.parse(client_data_json)

      # First check that the type is "webauthn.create" and the challenge matches
      if client_data["type"] != "webauthn.get"
        raise "Passkey operation type is not webauthn.get"
      elsif Base64.decode64(client_data["challenge"]) != session[:authentication_challenge]
        raise "Passkey challenge does not match"
      end

      # Verify the authenticator data
      rp_id_hash = authenticator_data[0..31]
      flags = authenticator_data[32].unpack1("C")
      sign_count = authenticator_data[33..36].unpack1("N")

      expected_rp_id_hash = OpenSSL::Digest::SHA256.digest(Rails.configuration.webauthn_rpid)
      raise "RP ID hash mismatch" unless rp_id_hash == expected_rp_id_hash
      raise "User not present" unless flags & 0x01 != 0

      # Load the associated credential from DB
      user_handle = Base64.decode64(params[:userHandle])
      cred = WebauthnCredential.joins(:user)
                               .where(credential_id: params[:id])
                               .where("core_users.webauthn_user_handle = ?", user_handle)
                               .first
      raise "Matching Passkey not found!" if cred.nil?

      # Update the sign_count if needed
      if sign_count > cred.sign_count
        cred.sign_count = sign_count
        cred.save!
      end

      # Decode the COSE key
      key = COSE::Key.deserialize(cred.public_key_cbor)
      openssl_pkey = key.to_pkey

      # Create the verification data
      verification_data = authenticator_data + OpenSSL::Digest::SHA256.digest(client_data_json)

      # Verify the signature
      is_valid = openssl_pkey.dsa_verify_asn1(OpenSSL::Digest::SHA256.digest(verification_data), signature)
      raise "Signature verification failed" unless is_valid
    rescue => e
      Rails.logger.error e.message + e.backtrace.join("\n")
      flash[:error] = e.message
      return redirect_back(fallback_location: admin_login_path)
    end

    # Do the regular Login chores
    cred.update_column(:last_used, DateTime.now)
    session[:user_id] = cred.user.id
    cred.user.record_login(request, 'admin')
    cookies[:domain_id] = {:value => Domain.first.id, :expires => 1.year.from_now} if cookies[:domain_id].nil?

    unless params[:redirect].blank?
      redirect_to params[:redirect]
      return
    end

    redirect_to cred.user.role.landing_page || admin_root_path
  end

  def destroy
    Log.create(user_id: session[:user_id],
               loggable_type: 'Session',
               loggable_id: session.id,
               event: 'destroyed',
               ip_address: request.remote_ip)

    reset_session
    cookies.delete :user_id

    redirect_to admin_login_path, notice: "You have been logged out."
  end
end
