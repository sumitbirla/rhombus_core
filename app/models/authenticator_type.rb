class AuthenticatorType < ActiveRecord::Base
  include Exportable

  self.table_name = "core_authenticator_types"
  has_many :webauthn_credentials, foreign_key: :aaguid
  validates_uniqueness_of :aaguid

  def to_s
    name
  end

  # PUNDIT
  def self.policy_class
    ApplicationPolicy
  end
end
