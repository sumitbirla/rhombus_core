require 'cbor'
require 'base64'

class Account::PasskeysController < Account::BaseController
  skip_before_action :verify_authenticity_token

  def index
    @credentials = WebauthnCredential.where(user_id: session[:user_id])

    # Set a webauthn user_handle in case one isn't already set
    if current_user.webauthn_user_handle.nil?
      current_user.update_column(:webauthn_user_handle, SecureRandom.uuid)
    end

    # Save challenge it for verification in create action
    @challenge = SecureRandom.base64(32)
    session[:challenge] = @challenge
  end

  def create
    client_data = JSON.parse(Base64.decode64(params[:clientDataJSON]))

    # First check that the type is "webauthn.create" and the challenge matches
    if client_data["type"] != "webauthn.create"
      return render plain: "Type is not webauthn.create", status: :bad_request
    elsif Base64.decode64(client_data["challenge"]) != session[:challenge]
      return render plain: "Challenge does not match", status: :bad_request
    end

    attestation_data = CBOR.decode(Base64.decode64(params[:attestationObject]))
    auth_data = parse_auth_data(attestation_data["authData"])
    public_key_cbor = auth_data[:attested_credential_data][:public_key_bytes]

    WebauthnCredential.create!(user_id: session[:user_id],
                               credential_id: params[:credential_id],
                               public_key_cbor: public_key_cbor,
                               rp_id: Rails.configuration.webauthn_rpid,
                               sign_count: auth_data[:sign_count])

    render plain: "Created", status: :ok
  end

  def destroy
    cred = WebauthnCredential.find_by(id: params[:id], user_id: session[:user_id])
    cred.destroy!

    redirect_to action: :index
  end


  private

  def parse_auth_data(auth_data)
    rp_id_hash = auth_data[0, 32]
    flags = auth_data[32].unpack1('C')
    sign_count = auth_data[33, 4].unpack1('N')

    # Initialize the index after the mandatory fields
    index = 37

    attested_credential_data = nil
    if flags & 0x40 != 0 # Check if the AT flag is set
      aaguid = auth_data[index, 16]
      index += 16

      credential_id_length = auth_data[index, 2].unpack1('n')
      index += 2

      credential_id = auth_data[index, credential_id_length]
      index += credential_id_length

      public_key_bytes = auth_data[index..-1]
      credential_public_key = CBOR.decode(public_key_bytes)

      attested_credential_data = {
        aaguid: aaguid,
        credential_id: credential_id,
        public_key_bytes: public_key_bytes,
        credential_public_key: credential_public_key
      }
    end

    {
      rp_id_hash: rp_id_hash,
      flags: flags,
      sign_count: sign_count,
      attested_credential_data: attested_credential_data
    }
  end
end
