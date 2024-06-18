require 'cbor'
require 'base64'

class Account::WebauthnCredentialsController < Account::BaseController
  skip_before_action :verify_authenticity_token

  def index
    @credentials = WebauthnCredential.where(user_id: session[:user_id])
                                     .order(created_at: :desc)

    # Set a webauthn user_handle in case one isn't already set
    if current_user.webauthn_user_handle.nil?
      current_user.update_column(:webauthn_user_handle, SecureRandom.uuid)
    end

    # Save challenge it for verification in create action
    @challenge = SecureRandom.base64(32)
    session[:creation_challenge] = @challenge
  end

  def create
    client_data = JSON.parse(Base64.decode64(params[:clientDataJSON]))

    # First check that the type is "webauthn.create" and the challenge matches
    if client_data["type"] != "webauthn.create"
      Rails.logger.error "Type is not webauthn.create"
      return render plain: "Type is not webauthn.create", status: :bad_request
    elsif Base64.decode64(client_data["challenge"]) != session[:creation_challenge]
      Rails.logger.error "Challenge does not match"
      return render plain: "Challenge does not match", status: :bad_request
    end

    attestation_data = CBOR.decode(Base64.decode64(params[:attestationObject]))
    auth_data = parse_auth_data(attestation_data["authData"])

    ap auth_data

    WebauthnCredential.create!(user_id: session[:user_id],
                               credential_id: params[:credential_id],
                               user_present: auth_data[:flags][:user_present],
                               user_verified: auth_data[:flags][:user_verified],
                               extension_data_included: auth_data[:flags][:extension_data_included],
                               aaguid: auth_data[:attested_credential_data][:aaguid],
                               rp_id: Rails.configuration.webauthn_rpid,
                               sign_count: auth_data[:sign_count],
                               public_key_cbor: auth_data[:attested_credential_data][:credential_public_key].to_cbor,
                               extension_data_cbor: auth_data[:extension_data]&.to_cbor)

    render plain: "Created", status: :ok
  end

  def edit
    @webauthn_credential = WebauthnCredential.find_by(id: params[:id], user_id: current_user.id)
  end

  def update
    @webauthn_credential = WebauthnCredential.find_by(id: params[:id], user_id: current_user.id)
    if @webauthn_credential.update(webauthn_credential_params)
      return redirect_to action: :index
    end

    render 'edit'
  end

  def destroy
    cred = WebauthnCredential.find_by(id: params[:id], user_id: session[:user_id])
    cred.destroy!

    redirect_to action: :index
  end


  private
  def webauthn_credential_params
    params.require(:webauthn_credential).permit(:nickname)
  end

  def parse_auth_data(auth_data)
    io = StringIO.new(auth_data)

    # rpIdHash: 32 bytes
    rp_id_hash = io.read(32)

    # Flags: 1 byte
    flags_byte = io.read(1).unpack1('C')
    flags = {
      user_present: (flags_byte & 0x01) != 0,
      user_verified: (flags_byte & 0x04) != 0,
      attested_credential_data: (flags_byte & 0x40) != 0,
      extension_data_included: (flags_byte & 0x80) != 0
    }

    # Sign Count: 4 bytes (big-endian unsigned integer)
    sign_count = io.read(4).unpack1('N')

    attested_credential_data = nil
    if flags[:attested_credential_data]
      # AAGUID: 16 bytes
      aaguid = io.read(16)

      # Credential ID Length: 2 bytes (big-endian unsigned integer)
      credential_id_length = io.read(2).unpack1('n')

      # Credential ID: credential_id_length bytes
      credential_id = io.read(credential_id_length)

      # Parse the Public Key and optionally Extension Data (if present)
      u = CBOR::Unpacker.new
      cbor_objects = []
      u.feed_each(io.read) { |x| cbor_objects << x }

      attested_credential_data = {
        aaguid: aaguid.unpack("H8H4H4H4H12").join("-"),
        credential_id: credential_id,
        credential_public_key: cbor_objects.first
      }
    end

    extension_data = nil
    if flags[:extension_data_included]
      extension_data = cbor_objects.last
    end

    {
      rp_id_hash: rp_id_hash,
      flags: flags,
      sign_count: sign_count,
      attested_credential_data: attested_credential_data,
      extension_data: extension_data
    }
  end
end
