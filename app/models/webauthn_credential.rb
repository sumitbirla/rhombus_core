class WebauthnCredential < ActiveRecord::Base
  include Exportable

  self.table_name = "core_webauthn_credentials"
  belongs_to :user

  # PUNDIT
  def self.policy_class
    ApplicationPolicy
  end
end
