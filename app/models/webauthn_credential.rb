class WebauthnCredential < ActiveRecord::Base
  include Exportable

  self.table_name = "core_webauthn_credentials"
  belongs_to :user
  has_one :authenticator_type, foreign_key: :aaguid, primary_key: :aaguid

  # PUNDIT
  def self.policy_class
    ApplicationPolicy
  end
end
