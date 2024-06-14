require 'cbor'

class Admin::System::WebauthnCredentialsController < Admin::BaseController
  def index
    authorize WebauthnCredential.new
    @webauthn_credentials = WebauthnCredential.order(created_at: :desc)

    respond_to do |format|
      format.html { @webauthn_credentials = @webauthn_credentials.paginate(page: params[:page], per_page: @per_page) }
      format.csv { send_data WebauthnCredential.to_csv(@webauthn_credentials) }
    end
  end

  def edit
    @webauthn_credential = WebauthnCredential.find(params[:id])
  end

  def update
    @webauthn_credential = WebauthnCredential.find(params[:id])

    if @webauthn_credential.update(webauthn_credential_params)
      Rails.cache.delete :printers
      redirect_to action: 'index', notice: 'Printer was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @webauthn_credential = WebauthnCredential.find(params[:id])
    @webauthn_credential.destroy!

    redirect_to action: 'index', notice: 'Passkey has been deleted.'
  end


  private
  def webauthn_credential_params
    params.require(:webauthn_credential).permit(:id, :nickname)
  end

  def sort_column
    params[:sort] || "core_users.id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
