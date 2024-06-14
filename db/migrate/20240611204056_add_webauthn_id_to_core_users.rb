class AddWebauthnIdToCoreUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :core_users, :webauthn_user_handle, :string, after: :id
  end
end
